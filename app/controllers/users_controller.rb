class UsersController < ApplicationController
  before_filter :doorkeeper_authorize!, if: :doorkeeper_request?
  before_filter :authenticate_user!, unless: :doorkeeper_request?, except: [:new, :lookup, :create]
  before_filter :find_model, except: [:show]
  after_action :verify_authorized, except: [:new, :create, :lookup, :show]
  include UserHelper
  require 'will_paginate/array'

  def index
    if params[:admission]
      @users = Rails.cache.fetch("admission_year/#{params[:admission]}", expire: 10.minutes) do
        LdapUser.find(:all, attribute: 'admissionYear',
                      value: params[:admission], order: :asc,
                      sort_by: "gn")
      end
    end

    @users ||= policy_scope(LdapUser)
    unless request.format.json?
      @users = @users.paginate(page: params[:page])
    end
    authorize @user
  end

  def search
    if params[:t].present? && params[:q].present?
      case params[:t]
      when 'name'
        @users = search_name(params[:q]).paginate(page: params[:page])
      when *searchable_fields.map(&:last)
        @users = search_attr(params[:t], params[:q]).paginate(page: params[:page])
      else
        flash.now[:error] = t('.unknown_type')
        @users = []
      end
    else
      if params[:t] || params[:q]
        flash.now[:error] = t('.incomplete_search')
        @users = []
        render :index
        return
      end
    end

    authorize @user
    render :index
  end

  def me
    authorize @user
    render :show
  end

  def show
    @user = LdapUser.find_cached(params[:id])
    if @user.nil?
      redirect_to users_path, notice: t('unknown_user')
    else
      authorize @user
    end
  end

  def new
    @chuser = ChalmersUser.new
    render :new, layout: 'small_box'
  end

  def lookup
    @chuser = ChalmersUser.new(chalmers_user_params)
    if @chuser.valid?
      if @chuser.it_student?
        lu = LdapUser.new(uid: @chuser.cid,
                          gn: @chuser.gn,
                          sn: @chuser.sn,
                          mail: @chuser.mail)
        @user = User.new(ldap_user: lu)
        render :register
      else
        @error = {title: t('activemodel.errors.models.chalmers_user.failures.register'),
                  body: t('activemodel.errors.models.chalmers_user.failures.register_help')}
        render :error
      end
    else
      render :new, layout: 'small_box'
    end
  end

  def create
    # TODO: do some sanity checks here so that curl-posts aren't allowd, thereby circumventing Chalmers-checks...
    lu               = LdapUser.new(user_register_params)
    lu.cn            = Configurable.default_display_format
    lu.homedirectory = Configurable.default_home_dir % {uid: lu.uid}
    lu.gidnumber     = Configurable.default_group_id
    lu.uidnumber     = next_uid
    @user = User.new(cid: lu.uid, ldap_user: lu)

    @user.password              = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

    p @user.acceptedUserAgreement
    p lu.acceptedUserAgreement
    if @user.valid?
      pw = encrypt_pw @user.password
      @user.ldap_user.userPassword = pw
      @user.password = pw
      @user.password_confirmation = pw

      @user.save!
      @user.ldap_user.save!
       sign_in(@user)
      render :dashboard
    else
      render :register
    end
  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    # @user.update_attributes(ldap_user_params)
    # if @user.valid? && @user.save
    # use this ^ to validate with Rails before LDAP validates
    if @user.update_attributes(ldap_user_params)
      redirect_to me_path, notice: I18n.translate('info_changed')
    else
      render :edit
    end
  end

  def dashboard
    authorize @user
  end

  private
    def find_model
      @db_user = current_user || User.find(doorkeeper_token.resource_owner_id)
      @user = @db_user.ldap_user
    end

    def ldap_user_params
      push_service_attrs = [:device, :api]
      params.require(:ldap_user).permit(:nickname, :mail, :cn, :gn, :sn,
                                        :telephonenumber, :preferredLanguage,
                                        { push_services: [{ pushbullet: push_service_attrs }, { pushover: push_service_attrs }] })
    end

    def user_register_params
      params.require(:user).permit(:uid, :password, :password_confirmation,
                                   :gn, :sn, :mail, :telephonenumber,
                                   :admissionYear, :nickname, :acceptedUserAgreement,
                                   :cn, :preferredLanguage)
    end

    def chalmers_user_params
      params.require(:chalmers_user).permit(:cid, :password)
    end

    def search_attr attribute, value, order = :asc
      LdapUser.all(order: order, sort_by: attribute, attribute: attribute, value: value)
    end

    def search_name query
      split = query.split ' '
      query_str = "&" + split.map! do |q|
        "(|(gn=#{q})(sn=#{q}))"
      end.join
      LdapUser.find(:all, filter: query_str)
    end

    # Return the next available uid number
    def next_uid
       LdapUser.all(limit: 1, sort_by: :uidnumber, order: :desc).first[:uidnumber]+1
    end

    def encrypt_pw pw, salt=nil
      ActiveLdap::UserPassword.ssha pw, salt
    end
end

class UsersController < ApplicationController
  before_filter :doorkeeper_authorize!, if: :doorkeeper_request?
  before_filter :authenticate_user!, unless: :doorkeeper_request?
  before_filter :find_model, except: [:index,:show]
  include UserHelper

  def index
    @show_restricted = show_restricted_fields?
    if params[:t].present? && params[:q].present?
      case params[:t]
      when 'name'
        @users = search_name params[:q]
      when *searchable_fields.map(&:last)
        @users = search params[:t], params[:q]
      else
        flash.now[:error] = t('.unknown_type')
        @users = []
      end
    else
      if params[:t] || params[:q]
        flash.now[:error] = t('.incomplete_search')
        @users = []
        return
      end

      if !params[:admission]
        @users = LdapUser.all(order: :asc, sort_by: "uid")
      else
        @users = LdapUser.find(:all, attribute: 'admissionYear',
                               value: params[:admission], order: :asc, sort_by: "gn")
      end
    end
  end

  def me
    @show_restricted = show_restricted_fields?
    render :show
  end

  def show
    @show_restricted = show_restricted_fields?
    @user = LdapUser.find(params[:id])
    if doorkeeper_request? || current_user.admin?
      flash.now[:notice] = I18n.translate('admin_override')
    elsif current_user != @user.db_user
      redirect_to :me, alert: I18n.translate('users.show.existential_crisis')
    end
  end

  def edit

  end

  def update
    # @user.update_attributes(ldap_user_params)
    # if @user.valid? && @user.save
    # use this ^ to validate with Rails before LDAP validates
    if @user.update_attributes(ldap_user_params)
      redirect_to me_path, notice: I18n.translate('info_changed')
    else
      render :edit
    end
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

    def doorkeeper_request?
      doorkeeper_token.present?
    end

    def show_restricted_fields?
      (current_user && current_user.admin?) || doorkeeper_request?
    end

    def search attribute, value, order = :asc
      LdapUser.all(order: order, sort_by: attribute, attribute: attribute, value: value)
    end

    def search_name query
      split = query.split ' '
      query_str = "&" + split.map! do |q|
        "(|(gn=#{q})(sn=#{q}))"
      end.join
      LdapUser.find(:all, filter: query_str)
    end
end

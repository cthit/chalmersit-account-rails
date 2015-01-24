class UsersController < ApplicationController
  before_filter :doorkeeper_authorize!, if: :doorkeeper_request?
  before_filter :authenticate_user!, unless: :doorkeeper_request?
  before_filter :find_model, except: [:index,:show]
  include UserHelper
  require 'will_paginate/array'

  def index
    @show_restricted = show_restricted_fields?
    if params[:t].present? && params[:q].present?
      case params[:t]
      when 'name'
        @users = search_name(params[:q]).paginate(page: params[:page])
      when *searchable_fields.map(&:last)
        @users = search(params[:t], params[:q]).paginate(page: params[:page])
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
        @users = LdapUser.all_cached.paginate(page: params[:page])
      else
        @users = Rails.cache.fetch("admission_year/#{params[:admission]}", expire: 10.minutes) do
          LdapUser.find(:all, attribute: 'admissionYear',
                        value: params[:admission], order: :asc,
                        sort_by: "gn")
        end.paginate(page: params[:page])
      end
    end
  end

  def me
    @show_restricted = show_restricted_fields?
    render :show
  end

  def show
    @show_restricted = show_restricted_fields?
    @user = LdapUser.find_cached(params[:id])
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

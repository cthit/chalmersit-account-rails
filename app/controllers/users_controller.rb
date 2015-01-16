class UsersController < ApplicationController
  before_filter :doorkeeper_authorize!, if: :doorkeeper_request?
  before_filter :authenticate_user!, unless: :doorkeeper_request?
  before_filter :find_model, except: :index

  def index
    @users = LdapUser.all(order: :asc, sort_by: "uid")
  end

  def show
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
                                        :notifyBy, { push_services: [{ pushbullet: push_service_attrs }, { pushover: push_service_attrs }] })
    end

    def doorkeeper_request?
      doorkeeper_token.present?
    end
end

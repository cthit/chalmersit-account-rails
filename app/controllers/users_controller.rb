class UsersController < ApplicationController
  before_filter :find_model

  def index
    @users = User.all
  end

  def show

  end

  def new
    @chuser = ChalmersUser.new
    render :new, layout: 'small_box'
  end

  def lookup
    cid = params[:user][:cid]
    password = params[:user][:password]
    @chuser = ChalmersUser.valid_password? cid, password
    if @chuser
      render :register
    else
      render :new, layout: 'small_box', alert: 'credentials invalid'
    end
  end

  def create

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
      @db_user = current_user
      @user = @db_user.ldap_user
    end

    def ldap_user_params
      push_service_attrs = [:api, :device]
      params.require(:ldap_user).permit(:nickname, :mail, :cn, :gn, :sn, :telephonenumber, :preferredLanguage, :notifyBy, { push_services: [{ pushbullet: push_service_attrs }, { pushover: push_service_attrs }] })
    end
end

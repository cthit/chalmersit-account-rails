class Admin::UsersController < ApplicationController
  before_filter :ensure_admin
  before_action :set_user, except: [:new, :create]

  def edit
    authorize @user
    render 'users/edit'
  end

  def update
    authorize @user
    # @user.update_attributes(ldap_user_params)
    # if @user.valid? && @user.save
    # use this ^ to validate with Rails before LDAP validates
    if @user.update_attributes(ldap_user_params)
      redirect_to user_path(@user), notice: I18n.translate('info_changed')
    else
      render :edit
    end
  end

  def new
    @user = User.new
    render 'admins/users/new'
  end

  def create
    # TODO: do some sanity checks here so that curl-posts aren't allowd, thereby circumventing Chalmers-checks...
    lu               = LdapUser.new(user_register_params)
    lu.cn            = Configurable.ldap_default_display_format
    lu.loginshell    = Configurable.ldap_default_login_shell
    lu.homedirectory = Configurable.ldap_default_home_dir % {uid: lu.uid}
    lu.gidnumber     = Configurable.ldap_default_group_id
    lu.uidnumber     = next_uid
    @user = User.new(cid: lu.uid, ldap_user: lu)

    @user.password              = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.valid?
      pw = encrypt_pw @user.password
      @user.ldap_user.userPassword = pw
      @user.password = pw
      @user.password_confirmation = pw
      @user.errors.add(:lol, "you have been spooked b j")
      p @user.errors

      begin
        @user.save!
        @user.ldap_user.save!
      rescue Exception => e
        p e
        p @user.errors
      end
      render 'admins/users/new'
    else
      render 'users/show'
    end
  end


  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_url, notice: 'The user was deleted' }
      format.json { head :no_content }
    end
  end

  private
    def set_user
        @user = LdapUser.find(params[:id])
    end

    def ldap_user_params
      push_service_attrs = [:device, :api]
      params.require(:ldap_user).permit(:nickname, :mail, :cn, :gn, :sn,
                                        :telephonenumber, :preferredLanguage, :avatar_upload,
                                        { push_services: [{ pushbullet: push_service_attrs }, { pushover: push_service_attrs }] })
    end

    def user_register_params
      params.require(:user).permit(:uid, :password, :password_confirmation,
                                   :gn, :sn, :mail, :telephonenumber,
                                   :admissionYear, :nickname, :acceptedUserAgreement,
                                   :cn, :preferredLanguage)
    end

    # Return the next available uid number
    def next_uid
       LdapUser.all(limit: 1, sort_by: :uidnumber, order: :desc).first[:uidnumber]+1
    end

    def encrypt_pw pw, salt=nil
      ActiveLdap::UserPassword.ssha pw, salt
    end
end

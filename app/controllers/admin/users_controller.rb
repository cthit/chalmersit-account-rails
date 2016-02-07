class Admin::UsersController < ApplicationController
  before_filter :ensure_admin
  before_action :set_user

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
    @user = LdapUser.new(gidNumber: next_gid)
    # User first user since a valid DN is required...
    @user.member = LdapUser.first.dn
    render 'admins/users/new'
  end

  def create
    container = ldap_user_params['container']
    filtered = filter_empty ldap_user_params

    @user = LdapUser.new(filtered)
    if @user.save
      render 'admins/users/show'
    else
      render 'admins/users/new'
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

    def next_gid
      LdapUser.all(limit: 1, sort_by: :gidNumber, order: :desc).first[:gidNumber]+1
    end

    def filter_empty ldap_params
      arrayvals = ldap_params.user_by{|k, v| v.kind_of?(Array)}
      pairs     = arrayvals[true].map { |k, vs| [k, vs.reject(&:blank?)] }
      new_h     = Hash[pairs.select { |k, vs| vs.present? }]
      new_h.reverse_merge(Hash[arrayvals[false]])
    end
end

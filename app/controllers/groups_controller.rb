class GroupsController < ApplicationController
  before_filter :doorkeeper_authorize!, if: :doorkeeper_request?
  before_action :verify_member_of, only: [:update, :edit]
  after_action :verify_authorized

  def index
    @groups = policy_scope(LdapGroup)
    @groups.each do |g|
      authorize g
    end
  end

  def show
    @group = LdapGroup.find_cached(params[:id])
    authorize @group
  end
  def edit
    @group = LdapGroup.find_cached(params[:id])
    authorize @group
  end

  def update
    @group = LdapGroup.find_cached(params[:id])
    authorize @group
    if @group.base != ldap_group_params['container']
      @group.connection.modify_rdn @group.dn, "cn=#{@group.cn}",
        true, ldap_group_params['container']
    end

    if @group.update_attributes(ldap_group_params)
      @group.invalidate_my_cache
      render 'groups/show'
    else
      render 'groups/edit'
    end
  end
private
  def verify_member_of
    if !current_user.member_of.include?(LdapGroup.find_cached(params[:id]))
      user_not_authorized
    end
  end
  def ldap_group_params
    params.require(:ldap_group).permit(:container, :displayName,:groupLogo, :type,
                                       description:[], mail:[], homepage:[], function: [])
  end
end

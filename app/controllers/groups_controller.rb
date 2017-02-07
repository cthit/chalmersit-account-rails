class GroupsController < ApplicationController
  before_filter :doorkeeper_authorize!, if: :doorkeeper_request?
  before_filter :authenticate_user!, unless: :doorkeeper_request?
  after_action :verify_authorized, unless: :doorkeeper_request?

  def index
    @groups = policy_scope(LdapGroup)
    @groups.each do |g|
      authorize g
    end
  end

  def show
    @group = LdapGroup.find_cached(params[:id])
    authorize @group unless doorkeeper_request?
  end
  def edit
    @group = LdapGroup.find_cached(params[:id])
    authorize @group
  end

  def update
    @group = LdapGroup.find_cached(params[:id])
    authorize @group

    if @group.update_attributes(ldap_group_params)
      @group.invalidate_my_cache
      render 'groups/show'
    else
      render 'groups/edit'
    end
  end
private
  def ldap_group_params
    params.require(:ldap_group).permit( mail:[], homepage:[], position:[])
  end
end

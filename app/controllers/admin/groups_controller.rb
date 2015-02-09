class Admin::GroupsController < ApplicationController
  before_filter :ensure_admin

  def show
    @group = LdapGroup.find(params[:id])
    render 'admins/groups/show'
  end

  def index
    @groups = LdapGroup.all(sort_by: :gidNumber, order: :asc)
    render 'admins/groups/index'
  end

  def edit
    @group = LdapGroup.find(params[:id])
    render 'admins/groups/edit'
  end

  def update
    @group = LdapGroup.find(params[:id])

    if @group.update_attributes(ldap_group_params)
      render 'admins/groups/show'
    else
      render 'admins/groups/edit'
    end

  end

  private
    def ldap_group_params
      params.require(:ldap_group).permit(:cn, :gidNumber, :displayName,:groupLogo, :type,
                                         description:[], mail:[], homepage:[], function:[])
    end
end

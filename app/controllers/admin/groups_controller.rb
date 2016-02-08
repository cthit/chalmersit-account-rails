class Admin::GroupsController < ApplicationController
  before_filter :ensure_admin
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  def show
    render 'admins/groups/show'
  end

  def index
    @groups = LdapGroup.all(sort_by: :gidNumber, order: :asc)
    render 'admins/groups/index'
  end

  def edit
    render 'admins/groups/edit'
  end

  def update
    if @group.base != ldap_group_params['container']
      @group.connection.modify_rdn @group.dn, "cn=#{@group.cn}",
        true, ldap_group_params['container']
    end

    if @group.update_attributes(ldap_group_params)
      @group.invalidate_my_cache
      render 'admins/groups/show'
    else
      render 'admins/groups/edit'
    end
  end

  def new
    @group = LdapGroup.new(gidNumber: next_gid)
    # User first user since a valid DN is required...
    @group.member = LdapUser.first.dn
    render 'admins/groups/new'
  end

  def create
    container = ldap_group_params['container']
    filtered = filter_empty ldap_group_params

    @group = LdapGroup.new(filtered)
    if @group.save
      render 'admins/groups/show'
    else
      render 'admins/groups/new'
    end
  end


  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to admin_groups_url, notice: 'The group was deleted' }
      format.json { head :no_content }
    end
  end

  private
    def set_group
        @group = LdapGroup.find(params[:id])
    end

    def ldap_group_params
      params.require(:ldap_group).permit(:container, :cn, :gidNumber, :displayName,:groupLogo, :type,
                                         description:[], mail:[], homepage:[], member:[], function:[], position:[])
    end

    def next_gid
      LdapGroup.all(limit: 1, sort_by: :gidNumber, order: :desc).first[:gidNumber]+1
    end

    def filter_empty ldap_params
      arrayvals = ldap_params.group_by{|k, v| v.kind_of?(Array)}
      pairs     = arrayvals[true].map { |k, vs| [k, vs.reject(&:blank?)] }
      new_h     = Hash[pairs.select { |k, vs| vs.present? }]
      new_h.reverse_merge(Hash[arrayvals[false]])
    end
end

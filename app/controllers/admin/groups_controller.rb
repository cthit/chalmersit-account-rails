class Admin::GroupsController < ApplicationController
  before_filter :ensure_admin

  def show
    @group = LdapGroup.find(params[:id])
    render 'admins/groups/show'
  end

  def index
    @groups = LdapGroup.all
    render 'admins/groups/index'
  end
end

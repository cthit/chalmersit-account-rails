class Admin::GroupsController < ApplicationController
  before_filter :ensure_admin
  prepend_view_path 'app/views/admin'

  def show
    @groups = LdapGroup.all
    render 'admins/groups/show'
  end

  def index
    @groups = LdapGroup.all
    render 'admins/groups/index'
  end
end

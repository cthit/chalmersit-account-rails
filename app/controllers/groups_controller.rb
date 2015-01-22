class GroupsController < ApplicationController
  def index
    @groups = LdapGroup.all
  end

  def show
    @group = LdapGroup.find(params[:id])
  end
end

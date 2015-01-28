class GroupsController < ApplicationController
  def index
    @groups = LdapGroup.all_cached
  end

  def show
    @group = LdapGroup.find_cached(params[:id])
  end
end

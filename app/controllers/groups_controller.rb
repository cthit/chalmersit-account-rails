class GroupsController < ApplicationController
  before_filter :doorkeeper_authorize!, if: :doorkeeper_request?

  def index
    @groups = LdapGroup.all_cached
  end

  def show
    @group = LdapGroup.find_cached(params[:id])
  end
end

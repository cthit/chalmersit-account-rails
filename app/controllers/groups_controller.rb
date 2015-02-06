class GroupsController < ApplicationController
  before_filter :doorkeeper_authorize!, if: :doorkeeper_request?
  after_action :verify_authorized

  def index
    @groups = LdapGroup.all_cached
  end

  def show
    @group = LdapGroup.find_cached(params[:id])
  end
end

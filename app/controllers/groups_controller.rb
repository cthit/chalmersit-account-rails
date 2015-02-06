class GroupsController < ApplicationController
  before_filter :doorkeeper_authorize!, if: :doorkeeper_request?
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
end

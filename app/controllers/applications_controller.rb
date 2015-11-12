class ApplicationsController < ApplicationController
  before_action :set_application, only: [:show, :new_subscription]
  include SubscriptionHelper

  def index
    @applications = Application.all
    render 'applications/index'
  end
  def show
    render 'applications/show'
  end
  def new_subscription
      add_subscription(current_user.id, @application.id)
      flash[:notice] = t('subscription_added')
      render 'applications/show'
  end
private
  def set_application
    @application = Application.find(params[:id])
  end
end

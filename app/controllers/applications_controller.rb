class ApplicationsController < ApplicationController
  before_action :set_application, except: [:index]
  helper_method :subscription_exists?
  include SubscriptionHelper

  def index
    @applications = Application.all
  end
  def show
  end
  def new_subscription
    if !subscription_exists?
      add_subscription(current_user.id, @application.id)
      flash[:notice] = t('subscription_added')
    end
    redirect_to application_path(@application)
  end
  def remove_subscription
    if subscription_exists?
      delete_subscription(current_user.id, @application.id)
      flash[:notice] = t('subscription_removed')
    end
    redirect_to application_path(@application)
  end
  def subscription_exists?
    subscription_exists(current_user.id, @application.id)
  end
private
  def set_application
    @application = Application.find(params[:id])
  end
end

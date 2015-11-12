class ApplicationsController < ApplicationController
  before_action :set_application, except: [:index]
  before_filter :restrict_access, only: [:push_to_subscribers]
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
  def push_to_subscribers
    tokens = token_builder(request.headers)
    notify_subscibers(@application, tokens)
    redirect_to applications_path
  end
private
  def token_builder(headers)
    puts headers['HTTP_PUSH_MESSAGE']
    {:message => headers['HTTP_PUSH_MESSAGE'], :title => headers['HTTP_PUSH_TITLE'], :url => headers['HTTP_PUSH_URL'], :url_title => headers['HTTP_PUSH_URL_TITLE']}
  end
  def subscription_exists?
    subscription_exists(current_user.id, @application.id)
  end
  def set_application
    @application = Application.find(params[:id])
  end
  def restrict_access
    authenticate_or_request_with_http_token do |token, options|
      Application.exists?(auth_token: token)
    end
  end
end

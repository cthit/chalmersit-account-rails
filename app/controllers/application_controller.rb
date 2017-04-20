class ApplicationController < ActionController::Base
  include Pundit
  before_filter :authenticate_user!

  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :layout_by_resource

  before_action :set_locale

  def layout_by_resource
    if devise_controller?
      'small_box'
    else
      'application'
    end
  end

  def new_session_path(scope)
    new_user_session_path
  end

  def session_path(scope)
    user_session_path
  end

  def set_locale
    if current_user && current_user.preferredLanguage && I18n.available_locales.include?(current_user.preferredLanguage.to_sym)
      I18n.locale = current_user.preferredLanguage
    else
      I18n.locale = "en"
    end
  end

  def ensure_admin
    authorize :admin, :index?
  end

  def doorkeeper_request?
    doorkeeper_token.present?
  end

  helper_method :session_path, :new_session_path

  private

  def user_not_authorized
    flash[:alert] = t('unauthorized')
    redirect_to(request.referrer || unauthenticated_root_path)
  end

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    if params[:return_to]
      params[:return_to]
    else
      unauthenticated_root_path
    end
  end

end

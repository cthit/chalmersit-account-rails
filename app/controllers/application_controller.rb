class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
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
    I18n.locale = current_user.preferredLanguage if current_user && current_user.preferredLanguage && I18n.available_locales.include?(current_user.preferredLanguage.to_sym)
  end

  helper_method :session_path, :new_session_path
end

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :layout_by_resource

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

  helper_method :session_path, :new_session_path
end

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You are not authorized to view this page, and have been redirected back to the home page."
    redirect_to root_url
  end
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if
    session[:user_id]
  end
  
  # Makes this a helper method so views can access
  helper_method :current_user
  
  def logged_in?
    current_user
  end
  helper_method :logged_in?
  
  def check_login
    redirect_to login_url, alert: "You need to log in to view this page." if current_user.nil?
  end
  
  
end

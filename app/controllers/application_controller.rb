class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :require_login

  private
  def require_login
    unless current_user
      redirect_to home_path
    end
  end

  def require_logout
    if current_user
      redirect_to stages_path
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def graph
    @graph = Koala::Facebook::API.new(current_user.oauth_token)
  end

end


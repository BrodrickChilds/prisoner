class ApplicationController < ActionController::Base
  protect_from_forgery

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def graph
    @graph = Koala::Facebook::API.new(current_user.oauth_token)
  end
end

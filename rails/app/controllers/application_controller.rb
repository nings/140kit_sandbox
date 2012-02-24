class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  private
  def current_user
    @current_user ||= Researcher.select(:id).where(id: session[:researcher_id]).first if session[:researcher_id]
  end
end

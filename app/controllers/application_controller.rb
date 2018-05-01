class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello
    render html: "hello, world!"
  end

  def current_user
  	@current_user  ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def current_user_id
	@current_user_id ||= session[:user_id]
  end
  
  helper_method :current_user
end

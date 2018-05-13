class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery prepend: true

  def hello
    render html: "hello, world!"
  end

  def current_user
  	@current_user  ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_user_id
	@current_user_id ||= session[:user_id]
  end
  def authenticate
      if request.authorization
        @api_user = User.find_by_apiKey(request.authorization)
      else
        render_unauthorized
      end
    end

    def render_unauthorized
		puts "estic aquiiiiiiiiiiiiiii"
      render json: {:error => 'Unauthorized'}.to_json, :status => 401
    end

    def render_not_found
      render :json => {:error => "not-found"}.to_json, :status => 404
    end
  helper_method :current_user
end

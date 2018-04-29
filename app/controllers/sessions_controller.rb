class SessionsController < ApplicationController
	def create
		@user = User.find_or_create_from_auth_hash(auth_hash)
		#raise :test 
		#current_user = @user
		session[:user_id] = @user.id
		redirect_to root_path
	end

	protected

	def auth_hash
		request.env['omniauth.auth']
	end
end

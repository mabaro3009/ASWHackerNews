class SessionsController < ApplicationController
	require "digest/sha1"

	def create
		
		if (not User.where(:uid => auth_hash.uid).exists?)
			@user = User.find_or_create_from_auth_hash(auth_hash)
			@user.update_attribute(:apiKey, Digest::SHA1.hexdigest(Time.now.to_s + rand(12341234).to_s)[1..10])	
		else
			@user = User.find_or_create_from_auth_hash(auth_hash)		
		end

		
		#raise :test 
		#current_user = @user
		
		session[:user_id] = @user.id
		redirect_to root_path
	end
	
	def logout
		session[:user_id] = nil
		redirect_to root_path
	end
	

	protected

	def auth_hash
		request.env['omniauth.auth']
	end
end

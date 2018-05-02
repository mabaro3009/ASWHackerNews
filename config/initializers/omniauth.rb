Rails.application.config.middleware.use OmniAuth::Builder do
	provider :twitter, 'twitter_api_key', 'twitter_api_secret'
	#provider :twitter, Rails.application.secrets.twitter_api_key, Rails.application.secrets.twitter_api_secret
end 
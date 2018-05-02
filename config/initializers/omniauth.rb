Rails.application.config.middleware.use OmniAuth::Builder do
	provider :twitter, 'twitter_api_key', 'twitter_api_secret'
end 
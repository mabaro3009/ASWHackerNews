Rails.application.config.middleware.use OmniAuth::Builder do
	provider :twitter, 'twitter_api_consumer', 'twitter_api_secret'
end 
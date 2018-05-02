Rails.application.config.middleware.use OmniAuth::Builder do
	provider :twitter, 'twitter_consumer', 'twitter_api_secret'
end 
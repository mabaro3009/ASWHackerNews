Rails.application.config.middleware.use OmniAuth::Builder do

#descomentar para hacer el heroku
	#provider :twitter, ENV["twitter_api_key"], ENV["twitter_api_secret"]

#Descomentar para usar el local
	provider :twitter, Rails.application.secrets.twitter_api_key, Rails.application.secrets.twitter_api_secret
end

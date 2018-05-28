class User < ApplicationRecord
has_many :posts
has_many :comments
has_many :upvotes

require "digest/sha1"
	def self.find_or_create_from_auth_hash(auth_hash)
		user = where(provider: auth_hash.provider, uid: auth_hash.uid).first_or_create
		user.update(
			name: auth_hash.info.nickname,
			profile_image: auth_hash.info.image,
			token: auth_hash.credentials.token,
			secret: auth_hash.credentials.secret,
			#apiKey: Digest::SHA1.hexdigest(Time.now.to_s + rand(12341234).to_s)[1..10]
			)
		user
	end

end

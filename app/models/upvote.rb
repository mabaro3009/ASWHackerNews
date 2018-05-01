class Upvote < ApplicationRecord
belongs_to :user
belongs_to :post, optional: true, counter_cache: true
belongs_to :comment, optional: true
validates :user_id, presence: true
end

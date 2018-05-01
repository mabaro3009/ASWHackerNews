class Comment < ApplicationRecord
belongs_to :user
belongs_to :post
belongs_to :parent, :class_name => 'Comment', optional: true
has_many :replies, :class_name => 'Comment',foreign_key: "parent_id", dependent: :destroy
has_many :upvotes
validates :user_id, presence: true
validates :parent, presence: true, if: "tipus != 'comment'"

after_initialize :init

def init
	self.votes ||=0
	
end

end

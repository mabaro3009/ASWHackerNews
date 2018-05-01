class Post < ApplicationRecord
belongs_to :user
has_many :comments
has_many :upvotes
validates :title, presence: true
scope :tipo, -> (tipo) {where tipo: tipo }


after_initialize :init

def init
	self.votes ||=0
	self.nComments ||=0
end
	
end

class Post < ApplicationRecord
belongs_to :user
validates :title, presence: true
scope :tipo, -> (tipo) {where tipo: tipo }


after_initialize :init

def init
	self.votes ||=0
	self.nComments ||=0
end
	
end

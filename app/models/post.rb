class Post < ApplicationRecord
belongs_to :user
has_many :comments, dependent: :destroy
has_many :upvotes
validates :title,  :tipo, presence: true
#validates: url, :uniqueness => { :message => "ya existe la ulr!" }
scope :tipo, -> (tipo) {where tipo: tipo }


after_initialize :init

def init
	self.votes ||=0
	self.nComments ||=0
end

end

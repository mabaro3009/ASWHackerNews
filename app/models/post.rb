class Post < ApplicationRecord
#belongs_to :user
validates :title, presence: true
scope :tipo, -> (tipo) {where tipo: tipo }
end

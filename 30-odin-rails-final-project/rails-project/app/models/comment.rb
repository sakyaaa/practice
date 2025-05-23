class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  has_many :likes, as: :likable, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  validates :body, presence: true, length: { minimum: 2 }
end

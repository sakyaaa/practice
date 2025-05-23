class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :likes, as: :likable, dependent: :destroy
  has_many :likers, through: :likes, source: :user

  validates :title, presence: true, length: { minimum: 6, maximum: 30 }
  validates :body, presence: true, length: { minimum: 10 }
end

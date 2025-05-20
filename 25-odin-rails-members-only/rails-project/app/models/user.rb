class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable

  validates :email, presence: true, uniqueness: true

  has_many :posts, dependent: :destroy
end

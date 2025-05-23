class FollowRequest < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :source, class_name: "User"

  validates :follower_id, presence: true, uniqueness: {
    scope: :source_id, conditions: -> { where(status: "pending") }
  }

  validates :source_id, presence: true
  validate :not_following_self

  private

  def not_following_self
    if follower_id == source_id
      errors.add(:base, "You cannot follow yourself")
    end
  end
end

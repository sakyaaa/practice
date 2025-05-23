class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable

  has_one_attached :avatar
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :follow_requests_as_follower, class_name: "FollowRequest", foreign_key: :follower_id
  has_many :follow_requests_as_source, class_name: "FollowRequest", foreign_key: :source_id

  has_many :followers, through: :follow_requests_as_source, source: :follower
  has_many :following, through: :follow_requests_as_follower, source: :source

  validates :name, presence: true, length: { minimum: 6, maximum: 30 }
  validates :email, presence: true, uniqueness: true
  validate :acceptable_avatar

  after_create :send_welcome_email

  def avatar_url
    if avatar.attached?
      avatar
    else
      gravatar_url
    end
  end

  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end

  def gravatar_url
    hash = Digest::MD5.hexdigest(email.downcase)
    "https://www.gravatar.com/avatar/#{hash}?s=200&d=identicon"
  end

  def acceptable_avatar
    return unless avatar.attached?

    unless avatar.blob.byte_size <= 5.megabyte
      errors.add(:avatar, "is too big (maximum is 5MB)")
    end

    acceptable_types = ["image/jpeg", "image/png", "image/gif"]
    unless acceptable_types.include?(avatar.blob.content_type)
      errors.add(:avatar, "must be a JPEG, PNG, or GIF")
    end
  end
end

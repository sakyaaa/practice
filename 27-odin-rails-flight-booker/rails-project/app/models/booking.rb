class Booking < ApplicationRecord
  belongs_to :flight
  has_many :passengers, dependent: :destroy
  accepts_nested_attributes_for :passengers

  validates :flight, presence: true
  validate :passengers_present

  private

  def passengers_present
    errors.add(:base, "At least one passenger is required") if passengers.empty?
  end
end

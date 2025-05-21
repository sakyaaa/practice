class Airport < ApplicationRecord
  has_many :departing_flights, class_name: "Flight", foreign_key: :departing_airport_id
  has_many :arriving_flights, class_name: "Flight", foreign_key: :arriving_airport_id

  validates :code, presence: true, length: { minimum: 3, maximum: 3 }
end

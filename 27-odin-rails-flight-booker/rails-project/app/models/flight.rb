class Flight < ApplicationRecord
  belongs_to :departing_airport, class_name: "Airport", foreign_key: :departing_airport_id
  belongs_to :arriving_airport, class_name: "Airport", foreign_key: :arriving_airport_id

  validates :start, :duration, presence: true

  scope :with_departure_airport, ->(code) {
    return all unless code.present?
    joins("INNER JOIN airports AS departure_airports ON flights.departing_airport_id = departure_airports.id")
      .where(departure_airports: { code: code })
  }

  scope :with_arrival_airport, ->(code) {
    return all unless code.present?
    joins("INNER JOIN airports AS arrival_airports ON flights.arriving_airport_id = arrival_airports.id")
      .where(arrival_airports: { code: code })
  }

  scope :on_date, ->(date) {
    return all unless date.present?
    where("DATE(start) = ?", Date.strptime(date, "%Y%m%d"))
  }

  def self.search(params)
    flights = all.includes(:departing_airport, :arriving_airport)
    
    flights
      .with_departure_airport(params[:departure_code])
      .with_arrival_airport(params[:arrival_code])
      .on_date(params[:date])
  end
end

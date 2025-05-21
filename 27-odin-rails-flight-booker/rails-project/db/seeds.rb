# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create airports first
%w[LAX SFO MIA ABC DEF].each do |code|
  Airport.find_or_create_by!(code: code)
end

# Create flights between airports
Airport.all.each do |departing_airport|
  Airport.excluding(departing_airport).each do |arriving_airport|
    Flight.find_or_create_by!(
      departing_airport: departing_airport,
      arriving_airport: arriving_airport,
      start: Time.current + rand(1..30).days,
      duration: "#{rand(1..5)}:00"
    )
  end
end

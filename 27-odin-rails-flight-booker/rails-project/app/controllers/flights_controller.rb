class FlightsController < ApplicationController
  before_action :set_search_options, only: [:index]

  # GET /flights
  def index
    @flights = Flight.search(search_params)
  end

  private
    def set_search_options
      @airports = cached_airports
      @dates = cached_dates
      @passengers = passenger_options
    end

    def cached_airports
      Rails.cache.fetch("airports", expires_in: 1.hour) do
        Airport.all.map { |a| [a.code, a.code] }
      end
    end

    def cached_dates
      Rails.cache.fetch("flight_dates", expires_in: 1.hour) do
        Flight.distinct.pluck(:start)
              .map { |date| [date.strftime("%B %d, %Y"), date.strftime("%Y%m%d")] }
              .sort_by { |_, value| value }
      end
    end

    def passenger_options
      (1..4).map { |num| ["#{num} #{num == 1 ? 'passenger' : 'passengers'}", num] }
    end

    def search_params
      params.permit(:departure_code, :arrival_code, :date, :passengers, :commit)
    end
end

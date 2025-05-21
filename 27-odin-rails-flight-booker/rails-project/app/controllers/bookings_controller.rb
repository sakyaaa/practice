class BookingsController < ApplicationController
  def new
    @flight = Flight.find(params[:flight_id])
    @booking = Booking.new
    @num_passengers = params[:passengers].to_i
    @num_passengers.times { @booking.passengers.build }
  end

  def create
    @booking = Booking.new(booking_params)
    @flight = @booking.flight

    if @booking.save
      redirect_to @booking, notice: "Booking was successfully created."
    else
      @num_passengers = booking_params[:passengers_attributes].size
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @booking = Booking.find(params[:id])
  end

  private

  def booking_params
    params.require(:booking).permit(:flight_id, passengers_attributes: [:name, :email])
  end
end 
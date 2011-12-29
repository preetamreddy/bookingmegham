class UpdateNumberOfDriversForExistingTripsAndBookings < ActiveRecord::Migration
  def up
		Trip.all.each do |trip|
			trip.number_of_drivers = 0
			trip.save!
		end
		Booking.all.each do |booking|
			booking.number_of_drivers = 0
			booking.save!
		end
  end

  def down
		Trip.all.each do |trip|
			trip.number_of_drivers = nil
			trip.save!
		end
		Booking.all.each do |booking|
			booking.number_of_drivers = nil
			booking.save!
		end
  end
end

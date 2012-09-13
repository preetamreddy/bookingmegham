class AddTaxiBookingsCounterToTrips < ActiveRecord::Migration
  def up
    add_column :trips, :taxi_bookings_counter, :integer, :default => 0

    Trip.reset_column_information
    Trip.find(:all).each do |trip|
      Trip.update_counters trip.id, :taxi_bookings_counter => trip.taxi_bookings.length
    end
  end

  def down
    remove_column :trips, :taxi_bookings_counter
  end
end

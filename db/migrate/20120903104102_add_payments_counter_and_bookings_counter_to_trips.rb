class AddPaymentsCounterAndBookingsCounterToTrips < ActiveRecord::Migration
  def up
    add_column :trips, :payments_counter, :integer, :default => 0
    add_column :trips, :bookings_counter, :integer, :default => 0

    Trip.reset_column_information
    Trip.find(:all).each do |trip|
      Trip.update_counters trip.id, :payments_counter => trip.payments.length,
        :bookings_counter => trip.bookings.length
    end
  end

  def down
    remove_column :trips, :payments_counter
    remove_column :trips, :bookings_counter
  end
end

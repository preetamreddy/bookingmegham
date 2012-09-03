class AddPaymentsCountAndBookingsCountToTrips < ActiveRecord::Migration
  def up
    add_column :trips, :payments_count, :integer, :default => 0
    add_column :trips, :bookings_count, :integer, :default => 0

    Trip.reset_column_information
    Trip.find(:all).each do |trip|
      Trip.update_counters trip.id, :payments_count => trip.payments.length,
        :bookings_count => trip.bookings.length
    end
  end

  def down
    remove_column :trips, :payments_count
    remove_column :trips, :bookings_count
  end
end

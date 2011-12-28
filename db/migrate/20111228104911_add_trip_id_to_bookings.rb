class AddTripIdToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :trip_id, :integer
  end
end

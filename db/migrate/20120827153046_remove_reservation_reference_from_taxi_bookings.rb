class RemoveReservationReferenceFromTaxiBookings < ActiveRecord::Migration
  def up
    remove_column :taxi_bookings, :reservation_reference
  end

  def down
    add_column :taxi_bookings, :reservation_reference, :string
  end
end

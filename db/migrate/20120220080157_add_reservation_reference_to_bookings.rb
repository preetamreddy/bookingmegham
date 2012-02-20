class AddReservationReferenceToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :reservation_reference, :string
  end
end

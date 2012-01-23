class AddGuestIdAndPropertyIdToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :guest_id, :integer
    add_column :bookings, :property_id, :integer
  end
end

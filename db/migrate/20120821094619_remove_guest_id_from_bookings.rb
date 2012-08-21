class RemoveGuestIdFromBookings < ActiveRecord::Migration
  def up
    remove_column :bookings, :guest_id
  end

  def down
    add_column :bookings, :guest_id, :integer
  end
end

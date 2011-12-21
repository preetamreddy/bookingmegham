class AddRoomTypeIdToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :room_type_id, :integer
  end
end

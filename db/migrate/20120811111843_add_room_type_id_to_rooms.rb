class AddRoomTypeIdToRooms < ActiveRecord::Migration
  def up
    add_column :rooms, :room_type_id, :integer

		Room.all.each do |room|
			if room.booking_id
				room.update_column(:room_type_id, room.booking.room_type_id)
			end
		end
  end

	def down
    remove_column :rooms, :room_type_id
	end
end

class AddRoomIdToLineItems < ActiveRecord::Migration
  def up
    add_column :line_items, :room_id, :integer

		Booking.all.each do |booking|
			booking.line_items.destroy_all
			if booking.ensure_availability_before_booking == 1
				booking.rooms.each do |room|
					date = room.check_in_date
					while date < room.check_out_date do
						line_item = room.line_items.build(room_type_id: room.room_type_id,
							date: date,
							booked_rooms: room.number_of_rooms,
							booking_id: room.booking_id)
						line_item.save!
						date += 1
					end
				end
			end
		end
  end

	def down
    remove_column :line_items, :room_id
	end
end

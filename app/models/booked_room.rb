class BookedRoom < ActiveRecord::Base

	belongs_to :room_type

	def BookedRoom.book_rooms (room_type_id, from_date, to_date, number_of_rooms)
		date = from_date
		while date < to_date do
			booked_room = find_or_initialize_by_room_type_id_and_for_date(room_type_id, date, :count => 0)
			booked_room.count += number_of_rooms
			booked_room.save
			date += 1
    end
	end

	def BookedRoom.cancel_rooms (room_type_id, from_date, to_date, number_of_rooms)
		date = from_date
		while date < to_date do
			booked_room = find_by_room_type_id_and_for_date(room_type_id, date)
			booked_room.count -= number_of_rooms
			booked_room.save
			date += 1
		end
	end
		
end

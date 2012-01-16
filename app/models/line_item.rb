class LineItem < ActiveRecord::Base

	belongs_to :booking
	
	belongs_to :room_type

	validates :booking_id, :room_type_id, :date, :booked_rooms, :presence => true

	def LineItem.booked_rooms(property_or_room_type, id, date)
		if property_or_room_type == :room_type
			bookings = LineItem.
				where("room_type_id = :id AND date = :date",
					{ :id => id, :date => date }).
				group(:room_type_id, :date).
				sum(:booked_rooms)
		else
			bookings = LineItem.
				joins('LEFT OUTER JOIN room_types ON
					room_types.id = line_items.room_type_id').
				where("property_id = :id AND date = :date",
					{ :id => id, :date => date }).
				group(:property_id, :date).
				sum(:booked_rooms)
		end
		return bookings[[id, date]]
	end

end

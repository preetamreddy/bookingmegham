class LineItem < ActiveRecord::Base

	belongs_to :booking
	
	belongs_to :room_type

	validates :booking_id, :room_type_id, :date, :booked_rooms, :presence => true

	def LineItem.booked_rooms(id, date, consider_blocked_rooms_as_booked)
		if consider_blocked_rooms_as_booked == 1
			bookings = LineItem.
				where("room_type_id = :id AND date = :date",
					{ :id => id, :date => date }).
				group(:room_type_id, :date).
				sum(:booked_rooms)
		else
			bookings = LineItem.
				where("room_type_id = :id AND date = :date AND blocked = 0",
					{ :id => id, :date => date }).
				group(:room_type_id, :date).
				sum(:booked_rooms)
		end

		return bookings[[id, date]]
	end

end

class LineItem < ActiveRecord::Base
	belongs_to :room

	validates :room_type_id, :date, :booked_rooms, :presence => true

	def LineItem.booked_rooms(id, date)
		bookings = LineItem.
			where("room_type_id = :id AND date = :date",
				{ :id => id, :date => date }).
			group(:room_type_id, :date).
			sum(:booked_rooms)

		return bookings[[id, date]]
	end
end

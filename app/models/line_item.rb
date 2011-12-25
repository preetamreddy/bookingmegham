class LineItem < ActiveRecord::Base

	belongs_to :booking
	
	belongs_to :room_type

	def LineItem.create(booking)
		date = booking.check_in_date
		while date < booking.check_out_date do
			line_item = LineItem.new(booking_id: booking.id,
										room_type_id: booking.room_type_id,
										date: date,
										number_of_rooms: booking.number_of_rooms)
			line_item.save
			date += 1
		end
	end

	def LineItem.delete(booking)
		line_items = LineItem.find_all_by_booking_id(booking.id)
		line_items.each { |line_item|
			line_item.destroy
		}
	end

end

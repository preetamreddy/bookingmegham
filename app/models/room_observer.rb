class RoomObserver < ActiveRecord::Observer
	def after_create(room)
		delta_total_price = room.total_price
		delta_service_tax = room.service_tax
		update_price_for_rooms_and_service_tax(room.booking, delta_total_price, delta_service_tax)

		add_line_items_for room
	end

	def after_update(room)
		delta_total_price = room.total_price - room.total_price_was
		delta_service_tax = room.service_tax - room.service_tax_was
		update_price_for_rooms_and_service_tax(room.booking, delta_total_price, delta_service_tax)

		update_line_items_for room
	end

	def after_destroy(room)
		delta_total_price = 0 - room.total_price
		delta_service_tax = 0 - room.service_tax
		update_price_for_rooms_and_service_tax(room.booking, delta_total_price, delta_service_tax)

		delete_line_items_for room
	end

	def update_price_for_rooms_and_service_tax(booking, delta_total_price, delta_service_tax)
		booking.update_attributes(:price_for_rooms => booking.price_for_rooms + delta_total_price,
			:service_tax => booking.service_tax + delta_service_tax)
	end

	def update_line_items_for(room)
		delete_line_items_for room
		add_line_items_for room
	end

	def delete_line_items_for(room)
		if room.line_items.any?
			room.line_items.destroy_all
		end
	end

	def add_line_items_for(room)
		if room.booking.ensure_availability_before_booking == 1
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

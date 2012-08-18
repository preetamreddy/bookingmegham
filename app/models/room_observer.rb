class RoomObserver < ActiveRecord::Observer
	def after_create(room)
		delta_total_price = room.total_price
		delta_service_tax = room.service_tax
		update_price_for_rooms_and_service_tax(room.booking, delta_total_price, delta_service_tax)
	end

	def after_update(room)
		delta_total_price = room.total_price - room.total_price_was
		delta_service_tax = room.service_tax - room.service_tax_was
		update_price_for_rooms_and_service_tax(room.booking, delta_total_price, delta_service_tax)
	end

	def after_destroy(room)
		delta_total_price = 0 - room.total_price
		delta_service_tax = 0 - room.service_tax
		update_price_for_rooms_and_service_tax(room.booking, delta_total_price, delta_service_tax)
	end

	def update_price_for_rooms_and_service_tax(booking, delta_total_price, delta_service_tax)
		booking.update_attributes(:price_for_rooms => booking.price_for_rooms + delta_total_price,
			:service_tax => booking.service_tax + delta_service_tax)
	end
end

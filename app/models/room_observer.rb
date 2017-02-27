class RoomObserver < ActiveRecord::Observer
	def after_create(room)
		delta_total_price = room.total_price
		delta_service_tax = room.service_tax
		delta_luxury_tax = room.luxury_tax
		delta_vat = room.vat
		update_price_for_rooms_and_service_tax(room.booking_id, delta_total_price, delta_service_tax, delta_luxury_tax, delta_vat)
	end

	def after_update(room)
		delta_total_price = room.total_price - room.total_price_was
		delta_service_tax = room.service_tax - room.service_tax_was
		delta_luxury_tax = room.luxury_tax - room.luxury_tax_was
		delta_vat = room.vat - room.vat_was
		update_price_for_rooms_and_service_tax(room.booking_id, delta_total_price, delta_service_tax, delta_luxury_tax, delta_vat)
	end

	def after_destroy(room)
		delta_total_price = 0 - room.total_price
		delta_service_tax = 0 - room.service_tax
		delta_luxury_tax = 0 - room.luxury_tax
		delta_vat = 0 - room.vat
		update_price_for_rooms_and_service_tax(room.booking_id, delta_total_price, delta_service_tax, delta_luxury_tax, delta_vat)
	end

	def update_price_for_rooms_and_service_tax(booking_id, delta_total_price, delta_service_tax, delta_luxury_tax, delta_vat)
		if delta_total_price != 0 or delta_service_tax != 0 or delta_luxury_tax != 0 or delta_vat != 0
      			booking = Booking.find(booking_id)
			booking.update_attributes(
				:price_for_rooms => booking.price_for_rooms + delta_total_price,
			  	:service_tax => booking.service_tax + delta_service_tax,
			  	:luxury_tax => booking.luxury_tax + delta_luxury_tax,
			  	:vat => booking.vat + delta_vat)
		end
	end
end

class BookingObserver < ActiveRecord::Observer
	def after_create(booking)
		delta_price_for_vas = booking.price_for_vas
		delta_price_for_rooms = booking.price_for_rooms
		delta_service_tax = booking.service_tax
		delta_luxury_tax = booking.luxury_tax
		delta_vat = booking.vat
		update_price_and_service_tax(booking.trip_id, delta_price_for_vas, delta_price_for_rooms, delta_service_tax, delta_luxury_tax, delta_vat)
    Trip.update_counters booking.trip_id, :bookings_counter => 1
	end

	def after_update(booking)
		delta_price_for_vas = booking.price_for_vas - booking.price_for_vas_was
		delta_price_for_rooms = booking.price_for_rooms - booking.price_for_rooms_was
		delta_service_tax = booking.service_tax - booking.service_tax_was
		delta_luxury_tax = booking.luxury_tax - booking.luxury_tax_was
		delta_vat = booking.vat - booking.vat_was
		update_price_and_service_tax(booking.trip_id, delta_price_for_vas, delta_price_for_rooms, delta_service_tax, delta_luxury_tax, delta_vat)
	end

	def after_destroy(booking)
		delta_price_for_vas = 0 - booking.price_for_vas
		delta_price_for_rooms = 0 - booking.price_for_rooms
		delta_service_tax = 0 - booking.service_tax
		delta_luxury_tax = 0 - booking.luxury_tax
		delta_vat = 0 - booking.vat
		update_price_and_service_tax(booking.trip_id, delta_price_for_vas, delta_price_for_rooms, delta_service_tax, delta_luxury_tax, delta_vat)
	end

	def update_price_and_service_tax(trip_id, delta_price_for_vas, delta_price_for_rooms, delta_service_tax, delta_luxury_tax, delta_vat)
		if delta_price_for_vas != 0 or delta_price_for_rooms != 0 or delta_service_tax != 0 or delta_luxury_tax != 0 or delta_vat != 0
			trip = Trip.find(trip_id)
			trip.update_attributes(
				:price_for_vas => trip.price_for_vas + delta_price_for_vas,
				:price_for_rooms => trip.price_for_rooms + delta_price_for_rooms,
			  	:service_tax => trip.service_tax + delta_service_tax,
			  	:luxury_tax => trip.luxury_tax + delta_luxury_tax,
			  	:vat => trip.vat + delta_vat)
		end
	end
end

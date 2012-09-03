class BookingObserver < ActiveRecord::Observer
	def after_create(booking)
		delta_total_price = booking.total_price
		delta_service_tax = booking.service_tax
		update_price_for_rooms_and_service_tax(booking.trip_id, delta_total_price, delta_service_tax)
    Trip.update_counters booking.trip_id, :bookings_counter => 1
	end

	def after_update(booking)
		delta_total_price = booking.total_price - booking.total_price_was
		delta_service_tax = booking.service_tax - booking.service_tax_was
		update_price_for_rooms_and_service_tax(booking.trip_id, delta_total_price, delta_service_tax)
	end

	def after_destroy(booking)
		delta_total_price = 0 - booking.total_price
		delta_service_tax = 0 - booking.service_tax
		update_price_for_rooms_and_service_tax(booking.trip_id, delta_total_price, delta_service_tax)
	end

	def update_price_for_rooms_and_service_tax(trip_id, delta_total_price, delta_service_tax)
    if delta_total_price != 0 or delta_service_tax != 0
      trip = Trip.find(trip_id)
		  trip.update_attributes(:price_for_rooms => trip.price_for_rooms + delta_total_price,
			  :service_tax => trip.service_tax + delta_service_tax)
    end
	end
end

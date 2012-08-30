class TaxiBookingObserver < ActiveRecord::Observer
	def after_create(taxi_booking)
		delta_total_price = taxi_booking.total_price
		update_price_for_transport(taxi_booking.trip_id, delta_total_price)
	end

	def after_update(taxi_booking)
		delta_total_price = taxi_booking.total_price - taxi_booking.total_price_was
		update_price_for_transport(taxi_booking.trip_id, delta_total_price)
	end

	def after_destroy(taxi_booking)
		delta_total_price = 0 - taxi_booking.total_price
		update_price_for_transport(taxi_booking.trip_id, delta_total_price)
	end

	def update_price_for_transport(trip_id, delta)
    if delta != 0
      trip = Trip.find(trip_id)
		  trip.update_attributes(:price_for_transport => trip.price_for_transport + delta)
    end
	end
end

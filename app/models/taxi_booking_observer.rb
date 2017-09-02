class TaxiBookingObserver < ActiveRecord::Observer
	def after_create(taxi_booking)
		delta_taxable_value = taxi_booking.taxable_value
		delta_cgst = taxi_booking.cgst
		delta_sgst = taxi_booking.sgst
		delta_igst = taxi_booking.igst
		delta_total_price = taxi_booking.total_price
		update_price_for_transport(taxi_booking.trip_id, delta_taxable_value, delta_cgst, delta_sgst, delta_igst, delta_total_price)
		Trip.update_counters taxi_booking.trip_id, :taxi_bookings_counter => 1
	end

	def after_update(taxi_booking)
		delta_taxable_value = taxi_booking.taxable_value - taxi_booking.taxable_value_was
		delta_cgst = taxi_booking.cgst - taxi_booking.cgst_was
		delta_sgst = taxi_booking.sgst - taxi_booking.sgst_was
		delta_igst = taxi_booking.igst - taxi_booking.igst_was
		delta_total_price = taxi_booking.total_price - taxi_booking.total_price_was
		update_price_for_transport(taxi_booking.trip_id, delta_taxable_value, delta_cgst, delta_sgst, delta_igst, delta_total_price)
	end

	def after_destroy(taxi_booking)
		delta_taxable_value = 0 - taxi_booking.taxable_value
		delta_cgst = 0 - taxi_booking.cgst
		delta_sgst = 0 - taxi_booking.sgst
		delta_igst = 0 - taxi_booking.igst
		delta_total_price = 0 - taxi_booking.total_price
		update_price_for_transport(taxi_booking.trip_id, delta_taxable_value, delta_cgst, delta_sgst, delta_igst, delta_total_price)
	end

	def update_price_for_transport(trip_id, delta_taxable_value, delta_cgst, delta_sgst, delta_igst, delta_total_price)
		if delta_taxable_value != 0 or delta_cgst != 0 or delta_sgst != 0 or delta_igst != 0 or delta_total_price != 0
			trip = Trip.find(trip_id)
			trip.update_attributes(
				:taxable_value => trip.taxable_value + delta_taxable_value,
				:cgst => trip.cgst + delta_cgst,
				:sgst => trip.sgst + delta_sgst,
				:igst => trip.igst + delta_igst,
				:price_for_transport => trip.price_for_transport + delta_total_price)
    end
	end
end

class BookingObserver < ActiveRecord::Observer
	def after_create(booking)
		delta_discount = booking.discount
		delta_taxable_value = booking.taxable_value
		delta_cgst = booking.cgst
		delta_sgst = booking.sgst
		delta_igst = booking.igst
		delta_price_for_vas = booking.price_for_vas
		delta_price_for_rooms = booking.price_for_rooms
		update_price_and_service_tax(booking.trip_id, delta_discount, delta_taxable_value, delta_cgst, delta_cgst, delta_igst,
			delta_price_for_vas, delta_price_for_rooms)
		Trip.update_counters booking.trip_id, :bookings_counter => 1
	end

	def after_update(booking)
		delta_discount = booking.discount - booking.discount_was
		delta_taxable_value = booking.taxable_value - booking.taxable_value_was
		delta_cgst = booking.cgst - booking.cgst_was
		delta_sgst = booking.sgst - booking.sgst_was
		delta_igst = booking.igst - booking.igst_was
		delta_price_for_vas = booking.price_for_vas - booking.price_for_vas_was
		delta_price_for_rooms = booking.price_for_rooms - booking.price_for_rooms_was
		update_price_and_service_tax(booking.trip_id, delta_discount, delta_taxable_value, delta_cgst, delta_cgst, delta_igst,
			delta_price_for_vas, delta_price_for_rooms)
	end

	def after_destroy(booking)
		delta_discount = 0 - booking.discount
		delta_taxable_value = 0 - booking.taxable_value
		delta_cgst = 0 - booking.cgst
		delta_sgst = 0 - booking.sgst
		delta_igst = 0 - booking.igst
		delta_price_for_vas = 0 - booking.price_for_vas
		delta_price_for_rooms = 0 - booking.price_for_rooms
		update_price_and_service_tax(booking.trip_id, delta_discount, delta_taxable_value, delta_cgst, delta_cgst, delta_igst,
			delta_price_for_vas, delta_price_for_rooms)
	end

	def update_price_and_service_tax(trip_id, delta_discount, delta_taxable_value, delta_cgst, delta_sgst, delta_igst,
				delta_price_for_vas, delta_price_for_rooms)
		if delta_discount != 0 or delta_taxable_value != 0 or delta_cgst != 0 or delta_sgst != 0 or delta_igst != 0 or delta_price_for_vas != 0 or delta_price_for_rooms != 0
			trip = Trip.find(trip_id)

			if trip.is_direct_booking?
				trip.update_attributes(
			  		:discount => trip.discount + delta_discount,
			  		:taxable_value => trip.taxable_value + delta_taxable_value,
			  		:cgst => trip.cgst + delta_cgst,
			  		:sgst => trip.sgst + delta_sgst,
			  		:igst => trip.igst + delta_igst,
					:price_for_vas => trip.price_for_vas + delta_price_for_vas,
					:price_for_rooms => trip.price_for_rooms + delta_price_for_rooms)
			else
				trip.update_attributes(
			  		:tac => trip.tac + delta_discount,
			  		:taxable_value => trip.taxable_value + delta_taxable_value,
			  		:cgst => trip.cgst + delta_cgst,
			  		:sgst => trip.sgst + delta_sgst,
			  		:igst => trip.igst + delta_igst,
					:price_for_vas => trip.price_for_vas + delta_price_for_vas,
					:price_for_rooms => trip.price_for_rooms + delta_price_for_rooms)
			end
		end
	end
end

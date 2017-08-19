class VasBookingObserver < ActiveRecord::Observer
	def after_create(vas_booking)
		delta_discount = vas_booking.discount
		delta_taxable_value = vas_booking.taxable_value
		delta_cgst = vas_booking.cgst
		delta_sgst = vas_booking.sgst
		delta_total_price = vas_booking.total_price
		update_vas_price_for(parent_of(vas_booking), delta_discount, delta_taxable_value, delta_cgst, delta_sgst, delta_total_price)
	end

	def after_update(vas_booking)
		delta_discount = vas_booking.discount - vas_booking.discount_was
		delta_taxable_value = vas_booking.taxable_value - vas_booking.taxable_value_was
		delta_cgst = vas_booking.cgst - vas_booking.cgst_was
		delta_sgst = vas_booking.sgst - vas_booking.sgst_was
		delta_total_price = vas_booking.total_price - vas_booking.total_price_was
		update_vas_price_for(parent_of(vas_booking), delta_discount, delta_taxable_value, delta_cgst, delta_sgst, delta_total_price)
	end

	def after_destroy(vas_booking)
		delta_discount = 0 - vas_booking.discount
		delta_taxable_value = 0 - vas_booking.taxable_value
		delta_cgst = 0 - vas_booking.cgst
		delta_sgst = 0 - vas_booking.sgst
		delta_total_price = 0 - vas_booking.total_price
		update_vas_price_for(parent_of(vas_booking), delta_discount, delta_taxable_value, delta_cgst, delta_sgst, delta_total_price)
	end

	def parent_of(vas_booking)
		if vas_booking.trip_id
			Trip.find(vas_booking.trip_id)
		elsif vas_booking.booking_id
			Booking.find(vas_booking.booking_id)
		end
	end

	def update_vas_price_for(model, delta_discount, delta_taxable_value, delta_cgst, delta_sgst, delta_total_price)
		if delta_discount != 0 or delta_taxable_value != 0 or delta_cgst != 0 or delta_sgst != 0 or delta_total_price != 0
			model.update_attributes(
				:discount => model.discount + delta_discount,
				:taxable_value => model.taxable_value + delta_taxable_value,
				:cgst => model.cgst + delta_cgst,
				:sgst => model.sgst + delta_sgst,
				:price_for_vas => model.price_for_vas + delta_total_price)	
		end
	end
end

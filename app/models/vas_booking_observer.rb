class VasBookingObserver < ActiveRecord::Observer
	def after_create(vas_booking)
		delta_vas_price = vas_booking.total_price
		update_vas_price_for(parent_of(vas_booking), delta_vas_price)
	end

	def after_update(vas_booking)
		delta_vas_price = vas_booking.total_price - vas_booking.total_price_was
		update_vas_price_for(parent_of(vas_booking), delta_vas_price)
	end

	def after_destroy(vas_booking)
		delta_vas_price = 0 - vas_booking.total_price
		update_vas_price_for(parent_of(vas_booking), delta_vas_price)
	end

	def parent_of(vas_booking)
		if vas_booking.trip_id
			Trip.find(vas_booking.trip_id)
		elsif vas_booking.booking_id
			Booking.find(vas_booking.booking_id)
		end
	end

	def update_vas_price_for(model, delta)
    if delta != 0
		  model.update_attributes(:price_for_vas => model.price_for_vas + delta)	
    end
	end
end

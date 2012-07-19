class BillingObserver < ActiveRecord::Observer
	observe :payment, :taxi_booking, :vas_booking, :booking

	def after_save(model)
		trip = Trip.find_by_id(model.trip_id)
		if trip
			update_payment_status_and_pay_by_date(trip)
		end
	end

	def after_destroy(model)
		trip = Trip.find_by_id(model.trip_id)
		if trip
			update_payment_status_and_pay_by_date(trip)
		end
	end

	def update_payment_status_and_pay_by_date(trip)
		if trip.paid == 0
			trip.update_attributes(:payment_status => Trip::NOT_PAID,
				:pay_by_date => (trip.created_at.to_date + 2) )
		else 
			if trip.balance_payment > 0
				trip.update_attributes(:payment_status => Trip::PARTIALLY_PAID,
				:pay_by_date => (trip.start_date - 21) )
			else
				trip.update_attributes(:payment_status => Trip::FULLY_PAID,
				:pay_by_date => nil)
			end
		end	
	end
end

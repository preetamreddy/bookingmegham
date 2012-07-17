class BillingObserver < ActiveRecord::Observer
	observe :payment, :taxi_booking, :vas_booking

	def after_save(model)
		trip = model.trip
		if trip
			if trip.paid == 0
				trip.update_attributes(:food_preferences => Trip::NOT_PAID,
					:medical_constraints => (trip.created_at.to_date + 2).to_s )
			else
				if trip.balance_payment > 0
					trip.update_attributes(:food_preferences => Trip::PARTIALLY_PAID,
						:medical_constraints => (trip.start_date - 21).to_s )
				else
					trip.update_attributes(:food_preferences => Trip::FULLY_PAID,
						:medical_constraints => nil)
				end
			end	
		end
	end

	def after_destroy(model)
		trip = model.trip
		if trip
			if trip.paid == 0
				trip.update_attributes(:food_preferences => Trip::NOT_PAID,
					:medical_constraints => (trip.created_at.to_date + 2).to_s )
			else 
				if trip.balance_payment > 0
					trip.update_attributes(:food_preferences => Trip::PARTIALLY_PAID,
					:medical_constraints => (trip.start_date - 21).to_s )
				else
					trip.update_attributes(:food_preferences => Trip::FULLY_PAID,
					:medical_constraints => nil)
				end
			end	
		end
	end
end

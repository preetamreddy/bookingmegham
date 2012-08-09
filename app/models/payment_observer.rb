class PaymentObserver < ActiveRecord::Observer
	def after_create(payment)
		delta_amount = payment.amount
		update_paid_amount(payment.trip, delta_amount)
	end

	def after_update(payment)
		delta_amount = payment.amount - payment.amount_was
		update_paid_amount(payment.trip, delta_amount)
	end

	def after_destroy(payment)
		delta_amount = 0 - payment.amount
		update_paid_amount(payment.trip, delta_amount)
	end

	def update_paid_amount(trip, delta)
		trip.update_attributes(:paid => trip.paid + delta)
	end
end
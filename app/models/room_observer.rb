class RoomObserver < ActiveRecord::Observer
	def after_create(room)
		delta_discount = room.discount
		delta_taxable_value = room.taxable_value
		delta_cgst = room.cgst
		delta_sgst = room.sgst
		delta_igst = room.igst
		delta_total_price = room.total_price
		update_price_for_rooms_and_service_tax(room.booking_id, delta_discount, delta_taxable_value, delta_cgst, delta_sgst, delta_igst, delta_total_price)
	end

	def after_update(room)
		delta_discount = room.discount - room.discount_was
		delta_taxable_value = room.taxable_value - room.taxable_value_was
		delta_cgst = room.cgst - room.cgst_was
		delta_sgst = room.sgst - room.sgst_was
		delta_igst = room.igst - room.igst_was
		delta_total_price = room.total_price - room.total_price_was
		update_price_for_rooms_and_service_tax(room.booking_id, delta_discount, delta_taxable_value, delta_cgst, delta_sgst, delta_igst, delta_total_price)
	end

	def after_destroy(room)
		delta_discount = 0 - room.discount
		delta_taxable_value = 0 - room.taxable_value
		delta_cgst = 0 - room.cgst
		delta_sgst = 0 - room.sgst
		delta_igst = 0 - room.igst
		delta_total_price = 0 - room.total_price
		update_price_for_rooms_and_service_tax(room.booking_id, delta_discount, delta_taxable_value, delta_cgst, delta_sgst, delta_igst, delta_total_price)
	end

	def update_price_for_rooms_and_service_tax(booking_id, delta_discount, delta_taxable_value, delta_cgst, delta_sgst, delta_igst, delta_total_price)
		if delta_discount != 0 or delta_taxable_value != 0 or delta_cgst != 0 or delta_cgst != 0 or delta_igst != 0 or delta_total_price != 0
			booking = Booking.find(booking_id)
			booking.update_attributes(
				:discount => booking.discount + delta_discount,
				:taxable_value => booking.taxable_value + delta_taxable_value,
			  	:cgst => booking.cgst + delta_cgst,
			  	:sgst => booking.sgst + delta_sgst,
			  	:igst => booking.igst + delta_igst,
				:price_for_rooms => booking.price_for_rooms + delta_total_price)
		end
	end
end

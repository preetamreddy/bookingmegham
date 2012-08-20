module BookingChartHelper
	def show_allocation_with_color_code(payment_status, attributes = {}, &block)
		if payment_status == Trip::NOT_PAID
			attributes["class"] = "not_paid"
		elsif payment_status == Trip::PARTIALLY_PAID
			attributes["class"] = "partially_paid"
		elsif payment_status == Trip::FULLY_PAID
			attributes["class"] = "fully_paid"
		elsif payment_status == Trip::CONFIRMED_NOT_PAID
			attributes["class"] = "confirmed_not_paid"
    else
      attributes["class"] = "text" 
		end
		content_tag("td", attributes, &block)
	end
end

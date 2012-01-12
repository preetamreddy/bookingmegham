module AvailabilityChartHelper
	def show_availability_with_color_codes(row, available_rooms, required_rooms, attributes = {}, &block)
		if available_rooms == 0
			attributes["class"] = "sold_out"
		elsif available_rooms < required_rooms && row == :property
			# attributes["style"] = "color: red"
			attributes["class"] = "cannot_service"
		elsif available_rooms < required_rooms && row == :room_type
			#attributes["style"] = "color: orange"
			attributes["class"] = "partial"
		elsif available_rooms >= required_rooms
			#attributes["style"] = "color: green"
			attributes["class"] = "available"
		end
		content_tag("td", attributes, &block)
	end
end

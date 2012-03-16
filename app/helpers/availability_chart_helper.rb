module AvailabilityChartHelper
	def show_availability_with_color_codes(row, available_rooms, required_rooms, attributes = {}, &block)
		if available_rooms == 0
			attributes["class"] = "sold_out"
		elsif available_rooms < required_rooms && row == :property
			attributes["class"] = "not_serviceble"
		elsif available_rooms < required_rooms && row == :room_type
			attributes["class"] = "partial"
		elsif available_rooms >= required_rooms
			attributes["class"] = "available"
		end
		content_tag("td", attributes, &block)
	end
end

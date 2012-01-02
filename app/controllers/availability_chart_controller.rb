class AvailabilityChartController < ApplicationController
  def index
		@chart_start_date = Date.new(y=2012, m=5, d=1)
		@days_to_show_in_chart = 10
		@line_items = LineItem.joins('LEFT OUTER JOIN room_types ON room_types.id = line_items.room_type_id').group(:room_type_id, :date).sum(:booked_rooms)
		@room_types = RoomType.select("id, room_type, number_of_rooms, property_id").order(:property_id, :price_for_double_occupancy)
	end
end

class AvailabilityChartController < ApplicationController
  def index
		session[:trip_id] = params[:trip_id]

		if session[:trip_id]
			session[:guest_id] = Trip.find(session[:trip_id]).guest_id

			@chart_start_date = Trip.find(session[:trip_id]).start_date
			@chart_end_date = Trip.find(session[:trip_id]).end_date
		else
			@chart_start_date = Time.now.to_date
			@chart_end_date = @chart_start_date + 10
		end

		@line_items = LineItem.joins('LEFT OUTER JOIN room_types ON room_types.id = line_items.room_type_id').group(:room_type_id, :date).sum(:booked_rooms)
		@room_types = RoomType.select("id, room_type, number_of_rooms, property_id").order(:property_id, :price_for_double_occupancy)

	end
end

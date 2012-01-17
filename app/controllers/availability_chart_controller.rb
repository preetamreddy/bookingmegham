class AvailabilityChartController < ApplicationController
  def index
		if params[:include_blocked_rooms]
			session[:consider_blocked_rooms_as_booked] = 
													params[:include_blocked_rooms]
		else
			session[:consider_blocked_rooms_as_booked] = 'Y'
		end

		if params[:trip_id]
			session[:trip_id] = params[:trip_id]
			session[:guest_id] = Trip.find(session[:trip_id]).guest_id
		end

		if session[:trip_id]
			trip = Trip.find(session[:trip_id])
			@rooms_required = trip.number_of_rooms
			@chart_start_date = trip.start_date
			@chart_end_date = trip.end_date
		else
			@rooms_required = 0
			@chart_start_date = Time.now.to_date
			@chart_end_date = @chart_start_date + 10
		end

		consider_blocked_rooms_as_booked = session[:consider_blocked_rooms_as_booked]

		@chart_date_range = (@chart_start_date...@chart_end_date)
		@chart_date_range_short = (@chart_start_date...@chart_end_date).to_a.collect { |date| l date, :format => :short }

		@availability = {}

		@properties = Property.order(:id)
		@properties.each do |property|
			@chart_date_range.each do |date|
				@availability.store(
						[:property, property.id, date], 
							property.available_rooms(date, consider_blocked_rooms_as_booked))
			end
		end

		@room_types = RoomType.order(:property_id, :price_for_double_occupancy)
		@room_types.each do |room_type|
			@chart_date_range.each do |date|
				@availability.store(
						[:room_type, room_type.id, date], 
							room_type.available_rooms(date, consider_blocked_rooms_as_booked))
			end
		end

	end
end

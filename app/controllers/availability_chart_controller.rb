class AvailabilityChartController < ApplicationController
  def index
		if params[:include_blocked_rooms] == nil
			@consider_blocked_rooms_as_booked = 1
		else
			@consider_blocked_rooms_as_booked = 
								params[:include_blocked_rooms]
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
			if params[:date]
				@chart_start_date = Date.civil(params[:date][:year].to_i,
														params[:date][:month].to_i,
														params[:date][:day].to_i)
			elsif params[:chart_start_date]
				@chart_start_date = Date.strptime(params[:chart_start_date], "%Y-%m-%d")
			else
				@chart_start_date = Time.now.to_date
			end

			if params[:number_of_days]
				@number_of_days = params[:number_of_days].to_i
			else
				@number_of_days = 10
			end

			@rooms_required = 0
			@chart_end_date = @chart_start_date + @number_of_days
		end

		consider_blocked_rooms_as_booked = @consider_blocked_rooms_as_booked

		@chart_date_range = (@chart_start_date...@chart_end_date)
		@chart_date_range_short = (@chart_start_date...@chart_end_date).to_a.collect { |date| l date, :format => :short }

		@availability = {}

		@properties = Property.order(:id).find_all_by_ensure_availability_before_booking(1)
		@properties.each do |property|
			@chart_date_range.each do |date|
				@availability.store([:property, property.id, date], 
					property.available_rooms(date, consider_blocked_rooms_as_booked))
			end
		end

		@room_types = RoomType.order(:property_id, :price_for_double_occupancy).find_all_by_property_id(@properties)
		@room_types.each do |room_type|
			@chart_date_range.each do |date|
				@availability.store([:room_type, room_type.id, date], 
					room_type.available_rooms(date, consider_blocked_rooms_as_booked))
			end
		end

	end
end

class AvailabilityChartController < ApplicationController
  def index
		if !params[:consider_blocked_rooms_as_booked]
			@consider_blocked_rooms_as_booked = 1
		else 
			@consider_blocked_rooms_as_booked = 
					params[:consider_blocked_rooms_as_booked].to_i
		end

		if params[:trip_id]
			session[:trip_id] = params[:trip_id].to_i
			session[:guest_id] = Trip.find(session[:trip_id]).guest_id
		end

		if session[:trip_id]
			trip = Trip.find(session[:trip_id])
			@rooms_required = trip.number_of_rooms
			@chart_start_date = trip.start_date
			@chart_end_date = trip.end_date
			@number_of_days = trip.number_of_days - 1
		else
			if params[:chart_start_date_arr]
				@chart_start_date = Date.civil(
														params[:chart_start_date_arr][:year].to_i,
														params[:chart_start_date_arr][:month].to_i,
														params[:chart_start_date_arr][:day].to_i)
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

			if params[:rooms_required]
				@rooms_required = params[:rooms_required].to_i
			else
				@rooms_required = 1
			end

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

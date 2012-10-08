class AvailabilityChartController < ApplicationController
  def index
    if params[:clear]
      session[:trip_id] = nil
      session[:customer_type] = nil
      session[:customer_id] = nil
    end

		if session[:trip_id]
			trip = Trip.scoped_by_account_id(current_user.account_id).find(session[:trip_id])
    end

		if params[:chart_start_date]
			@chart_start_date = params[:chart_start_date].to_date
    elsif session[:trip_id]
			@chart_start_date = trip.start_date
		else
			@chart_start_date = Date.today
		end

		if params[:chart_end_date]
			@chart_end_date = params[:chart_end_date].to_date
    elsif session[:trip_id]
      @chart_end_date = trip.end_date
		else
			@chart_end_date = Date.today + 10
		end

		if params[:rooms_required]
			@rooms_required = params[:rooms_required].to_i
    elsif session[:trip_id]
      @rooms_required = trip.number_of_rooms
		else
			@rooms_required = 1
		end

		@chart_date_range = (@chart_start_date..@chart_end_date)
		@chart_date_range_short = (@chart_start_date..@chart_end_date).to_a.collect { |date| l date, :format => :short }

		@availability = {}

		@properties = Property.scoped_by_account_id(current_user.account_id).
										order(:name).find_all_by_ensure_availability_before_booking(1)
		@properties.each do |property|
			@chart_date_range.each do |date|
				@availability.store([:property, property.id, date], 
					property.available_rooms(date))
			end
		end

		@room_types = RoomType.scoped_by_account_id(current_user.account_id).
										order(:property_id, :price_for_double_occupancy).
										find_all_by_property_id_and_deleted(@properties, 0)
		@room_types.each do |room_type|
			@chart_date_range.each do |date|
				@availability.store([:room_type, room_type.id, date], 
					room_type.available_rooms(date))
			end
		end

	end
end

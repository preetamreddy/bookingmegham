class AvailabilityChartController < ApplicationController
  def index
		if params[:trip_id]
			session[:trip_id] = params[:trip_id]
			session[:guest_id] = Trip.find(session[:trip_id]).guest_id
		end

		if session[:trip_id]
			trip = Trip.find(session[:trip_id])
			@chart_start_date = trip.start_date
			@chart_end_date = trip.end_date
		else
			@chart_start_date = Time.now.to_date
			@chart_end_date = @chart_start_date + 10
		end

		@chart_date_range = (@chart_start_date...@chart_end_date).to_a.collect {
													|date| l date, :format => :short }

		@properties = Property.order(:id)
		line_items_by_property = LineItem.
			joins('LEFT OUTER JOIN room_types ON 
				room_types.id = line_items.room_type_id').
			where("date >= :start_date AND date < :end_date",
				{:start_date => @chart_start_date, :end_date => @chart_end_date}).
			group(:property_id, :date).
			sum(:booked_rooms)

		@availability = {}
		@properties.each do |property|
			@chart_date_range.each do |date|
				booked_rooms = line_items_by_property[[property.id, date]]
				if booked_rooms
					@availability.store(
						[:property, property.id, date], (property.number_of_rooms - booked_rooms))
				else
					@availability.store(
						[:property, property.id, date], property.number_of_rooms)
				end
			end
		end

		@room_types = RoomType.order(:property_id, :price_for_double_occupancy)
		line_items_by_room_type = LineItem.
			joins('LEFT OUTER JOIN room_types ON 
				room_types.id = line_items.room_type_id').
			group(:room_type_id, :date).
			sum(:booked_rooms)

		@room_types.each do |room_type|
			@chart_date_range.each do |date|
				booked_rooms = line_items_by_room_type[[room_type.id, date]]
				if booked_rooms
					@availability.store(
						[:room_type, room_type.id, date], (room_type.number_of_rooms - booked_rooms))
				else
					@availability.store(
						[:room_type, room_type.id, date], room_type.number_of_rooms)
				end
			end
		end

	end
end

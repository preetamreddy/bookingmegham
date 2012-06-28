class BookingChartController < ApplicationController 
  def index
		if params[:property_id]
			@property_id = params[:property_id].to_i
		else
			@property_id = Property.scoped_by_account_id(current_user.account_id).order("name").
				find_by_ensure_availability_before_booking(1).id
		end

		if params[:chart_start_date]
			@chart_start_date = Date.civil(
				params[:chart_start_date][:year].to_i,
				params[:chart_start_date][:month].to_i,
				params[:chart_start_date][:day].to_i)
		else
			@chart_start_date = Date.today
		end

		if params[:number_of_days]
			@number_of_days = params[:number_of_days].to_i
		else
			@number_of_days = 10 
		end

		@chart_end_date = @chart_start_date + @number_of_days - 1

		@chart_date_range = @chart_start_date..@chart_end_date
    @chart_date_range_short = (@chart_start_date..@chart_end_date).to_a.collect { |date| l date, :format => :short }


		alloted_rooms = {}
		@booking_chart = {}

		@room_types = RoomType.scoped_by_account_id(current_user.account_id).find_all_by_property_id(@property_id)

		@room_types.each do |room_type|
			available_rooms = (1..room_type.number_of_rooms).to_a

			in_camp = Booking.scoped_by_account_id(current_user.account_id).
				order("check_in_date, number_of_rooms desc").
				find(:all, :conditions => 
				[ 'room_type_id = ? and check_in_date <= ? and check_out_date > ? and cancelled = ?',
				room_type.id, @chart_start_date, @chart_start_date, 0 ])

			in_camp.each do |booking|
				alloted_rooms[booking.id] = []
				booking.rooms.each do |room|
					room.number_of_rooms.times do
						room_number = available_rooms.shift
						alloted_rooms[booking.id] << room_number
						in_camp_dates = @chart_start_date...booking.check_out_date
						in_camp_dates.each do	|date|
							@booking_chart.store([room_type.id, room_number, date], [
								booking.trip.guest.name + room.guests_per_room, booking.trip.payment_status])
						end
					end
				end
			end

			available_rooms.each do |room_number|
				@booking_chart.store([room_type.id, room_number, @chart_start_date], ["", ""])
			end

			date_range = (@chart_start_date + 1)..@chart_end_date
			date_range.each do |date|
				check_outs = Booking.scoped_by_account_id(current_user.account_id).find(:all, :conditions => [
					'room_type_id = ? and check_out_date = ? and cancelled = ?', room_type.id, date, 0 ])
				check_outs.each do |booking|
					alloted_rooms[booking.id].each do |room_number|
						available_rooms.push(room_number)	
					end
				end

				check_ins = Booking.scoped_by_account_id(current_user.account_id).order("number_of_rooms desc").
					find(:all, :conditions => [
					'room_type_id = ? and check_in_date = ? and cancelled = ?', room_type.id, date, 0 ])
				check_ins.each do |booking|
					alloted_rooms[booking.id] = []
					available_rooms = sort_for_contiguous_rooms(available_rooms,
						booking.number_of_rooms)
					booking.rooms.each do |room|
						room.number_of_rooms.times do
							room_number = available_rooms.shift
							alloted_rooms[booking.id] << room_number
							in_camp_dates = booking.check_in_date...booking.check_out_date
							in_camp_dates.each do |date|
								@booking_chart.store([room_type.id, room_number, date],
									[booking.trip.guest.name + room.guests_per_room, booking.trip.payment_status])
							end
						end
					end
				end

				available_rooms.each do |room_number|
					@booking_chart.store([room_type.id, room_number, date], ["", ""])
				end
			end
		end
	end
end

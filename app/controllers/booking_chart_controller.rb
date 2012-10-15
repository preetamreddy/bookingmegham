class BookingChartController < ApplicationController 
  def index
		if session[:trip_id]
			trip = Trip.scoped_by_account_id(current_user.account_id).find(session[:trip_id])
    end

		if params[:property_id]
      property_id = params[:property_id].to_i
      if Property.scoped_by_account_id(current_user.account_id).find_all_by_id(property_id).any?
        @property_name = Property.scoped_by_account_id(current_user.account_id).find(property_id).name
			  @property_id = property_id
      end
		else
			properties = Property.scoped_by_account_id(current_user.account_id).order("name").
				find_all_by_ensure_availability_before_booking(1)
			@property_id = properties.first.id if properties.count > 0
			@property_name = properties.first.name if properties.count > 0
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

		@chart_date_range = @chart_start_date..@chart_end_date
    @chart_date_range_short = (@chart_start_date..@chart_end_date).to_a.collect { |date| l date, :format => :short }


		alloted_rooms = {}
		@booking_chart = {}

		@room_types = RoomType.scoped_by_account_id(current_user.account_id).
      find_all_by_property_id_and_deleted(@property_id, 0)

		@room_types.each do |room_type|
			available_rooms = (1..room_type.number_of_rooms).to_a

			in_camp = Room.scoped_by_account_id(current_user.account_id).
				order("check_in_date, number_of_rooms desc").
				find(:all, :conditions => [
					'room_type_id = ? and check_in_date <= ? and check_out_date > ?',
					room_type.id, @chart_start_date, @chart_start_date ])

			in_camp.each do |room|
				if room.cancelled == 0
					alloted_rooms[room.id] = []
					room.number_of_rooms.times do
						room_number = available_rooms.shift
						alloted_rooms[room.id] << room_number
						in_camp_dates = @chart_start_date...room.check_out_date
						in_camp_dates.each do	|date|
							@booking_chart.store([room_type.id, room_number, date], [
                room.booking.trip.guest_name_with_agency + " x " +  room.guests_per_room + "\n" + room.booking.remarks,
                room.booking.trip.guest_name_with_agency[0,18] + " x " +  room.guests_per_room, 
                room.booking.trip.payment_status, room.booking_id])
						end
					end
				end
			end

			available_rooms.each do |room_number|
				@booking_chart.store([room_type.id, room_number, @chart_start_date], ["", "", "", ""])
			end

			date_range = (@chart_start_date + 1)..@chart_end_date
			date_range.each do |date|
				check_outs = Room.scoped_by_account_id(current_user.account_id).find(:all, :conditions => [
					'room_type_id = ? and check_out_date = ?', room_type.id, date ])
				check_outs.each do |room|
					if room.cancelled == 0
						alloted_rooms[room.id].each do |room_number|
							available_rooms.push(room_number)	
						end
					end
				end

				check_ins = Room.scoped_by_account_id(current_user.account_id).order("number_of_rooms desc").
					find(:all, :conditions => [
					'room_type_id = ? and check_in_date = ?', room_type.id, date ])
				check_ins.each do |room|
					if room.cancelled == 0
						alloted_rooms[room.id] = []
						available_rooms = sort_for_contiguous_rooms(available_rooms, room.number_of_rooms)
						room.number_of_rooms.times do
							room_number = available_rooms.shift
							alloted_rooms[room.id] << room_number
							in_camp_dates = room.check_in_date...room.check_out_date
							in_camp_dates.each do |date|
								@booking_chart.store([room_type.id, room_number, date], [
                  room.booking.trip.guest_name_with_agency + " x " +  room.guests_per_room + "\n" + room.booking.remarks,
                  room.booking.trip.guest_name_with_agency[0,18] + " x " +  room.guests_per_room,
                  room.booking.trip.payment_status, room.booking_id])
							end
						end
					end
				end

				available_rooms.each do |room_number|
					@booking_chart.store([room_type.id, room_number, date], ["", "", "", ""])
				end
			end
		end
	end

  private
	  def sort_for_contiguous_rooms(available_rooms, rooms_required)
	    available_rooms = available_rooms.sort
	    first_room_number = 0
	    i = 0
	    while (available_rooms.length - rooms_required + 1 - i) > 0
	      (0..(rooms_required - 1)).each do |r|
	        n = available_rooms.first
	        if available_rooms.index(n + r)
	          first_room_number = n
	        else
	          first_room_number = 0
	          break
	        end
	      end
	      if first_room_number > 0
	        break
	      else
	        i += 1
	        available_rooms = available_rooms.rotate
	      end
	    end
	    return available_rooms
	  end
end

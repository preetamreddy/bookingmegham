class LineItemsController < ApplicationController 
# GET /line_items 
# GET /line_items.json
  def index
		if params[:property_id]
			@property_id = params[:property_id].to_i
		else
			@property_id = Property.find_by_name('Sangla').id
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
		@line_items = {}

		@room_types = RoomType.find_all_by_property_id(@property_id)

		@room_types.each do |room_type|
			available_rooms = (1..room_type.number_of_rooms).to_a

			in_camp = Booking.order("check_in_date, number_of_rooms desc").
				find(:all, :conditions => 
				[ 'room_type_id = ? and check_in_date <= ? and check_out_date > ?',
				room_type.id, @chart_start_date, @chart_start_date ])

			in_camp.each do |booking|
				alloted_rooms[booking.id] = []
				booking.rooms.each do |room|
					room.number_of_rooms.times do
						room_number = available_rooms.shift
						alloted_rooms[booking.id] << room_number
						in_camp_dates = @chart_start_date...booking.check_out_date
						in_camp_dates.each do	|date|
							@line_items.store([room_type.id, room_number, date], [
								booking.trip.guest.name + room.guests_per_room, booking.trip.payment_status])
						end
					end
				end
			end

			available_rooms.each do |room_number|
				@line_items.store([room_type.id, room_number, @chart_start_date], ["", ""])
			end

			date_range = (@chart_start_date + 1)..@chart_end_date
			date_range.each do |date|
				check_outs = Booking.find(:all, :conditions => [
					'room_type_id = ? and check_out_date = ?', room_type.id, date ])
				check_outs.each do |booking|
					alloted_rooms[booking.id].each do |room_number|
						available_rooms.push(room_number)	
					end
				end

				check_ins = Booking.order("number_of_rooms desc").
					find(:all, :conditions => [
					'room_type_id = ? and check_in_date = ?', room_type.id, date ])
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
								@line_items.store([room_type.id, room_number, date],
									[booking.trip.guest.name + room.guests_per_room, booking.trip.payment_status])
							end
						end
					end
				end

				available_rooms.each do |room_number|
					@line_items.store([room_type.id, room_number, date], ["", ""])
				end
			end
		end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @line_items }
    end
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/new
  # GET /line_items/new.json
  def new
    @line_item = LineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/1/edit
  def edit
    @line_item = LineItem.find(params[:id])
  end

  # POST /line_items
  # POST /line_items.json
  def create
    @line_item = LineItem.new(params[:line_item])

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @line_item, notice: 'Line item was successfully created.' }
        format.json { render json: @line_item, status: :created, location: @line_item }
      else
        format.html { render action: "new" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /line_items/1
  # PUT /line_items/1.json
  def update
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      if @line_item.update_attributes(params[:line_item])
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to line_items_url }
      format.json { head :ok }
    end
  end
end

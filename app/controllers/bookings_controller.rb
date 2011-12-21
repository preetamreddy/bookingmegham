class BookingsController < ApplicationController
  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = Booking.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bookings }
    end
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
    @booking = Booking.find(params[:id])
		@booking.revert_to(params[:version].to_i) if params[:version]

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @booking }
    end
  end

  # GET /bookings/new
  # GET /bookings/new.json
  def new
    @booking = Booking.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @booking }
    end
  end

  # GET /bookings/1/edit
  def edit
    @booking = Booking.find(params[:id])
  end

  # POST /bookings
  # POST /bookings.json
  def create
    @booking = Booking.new(params[:booking])

    respond_to do |format|
      if @booking.save

				BookedRoom.book_rooms(@booking.room_type_id, @booking.from, 
					@booking.to, @booking.number_of_rooms)

        format.html { redirect_to @booking, notice: 'Booking was successfully created.' }
        format.json { render json: @booking, status: :created, location: @booking }
      else
        format.html { render action: "new" }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bookings/1
  # PUT /bookings/1.json
  def update
    @booking = Booking.find(params[:id])
		old_room_type_id = @booking.room_type_id
		old_from_date = @booking.from
		old_to_date = @booking.to
		old_number_of_rooms = @booking.number_of_rooms

    respond_to do |format|
      if @booking.update_attributes(params[:booking])
				if (@booking.room_type_id != old_room_type_id ||
						@booking.from != old_from_date ||
						@booking.to != old_to_date ||
						@booking.number_of_rooms != old_number_of_rooms)
							BookedRoom.cancel_rooms(old_room_type_id, old_from_date, 
								old_to_date, old_number_of_rooms)
							BookedRoom.book_rooms(@booking.room_type_id, @booking.from, 
								@booking.to, @booking.number_of_rooms)
				end

        format.html { redirect_to @booking, notice: 'Booking was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy

		BookedRoom.cancel_rooms(@booking.room_type_id, @booking.from, @booking.to,
			@booking.number_of_rooms)

    respond_to do |format|
      format.html { redirect_to bookings_url }
      format.json { head :ok }
    end
  end
end

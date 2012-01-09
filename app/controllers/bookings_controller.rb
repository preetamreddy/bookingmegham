class BookingsController < ApplicationController
  # GET /bookings
  # GET /bookings.json
  def index
		if params[:trip_id]
			session[:trip_id] = params[:trip_id]
			session[:guest_id] = Trip.find(session[:trip_id]).guest_id
		end
			
		if session[:trip_id]
			@bookings = Booking.order("check_in_date, check_out_date").find_all_by_trip_id(session[:trip_id])
		else
			if session[:guest_id]
				trips = Trip.select("id").find_all_by_guest_id(session[:guest_id])
				@bookings = Booking.order("check_in_date, check_out_date").find_all_by_trip_id(trips)
			else
				@bookings = Booking.order("check_in_date, check_out_date").all
			end
		end

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
		if params[:trip_id]
			session[:trip_id] = params[:trip_id]
			session[:guest_id] = Trip.find(session[:trip_id]).guest_id
		end

    @booking = Booking.new
		@booking.room_type_id = params[:room_type_id]
		
		if session[:trip_id]	
			trip = Trip.find(session[:trip_id])

			@booking.trip_id = session[:trip_id]
			@booking.number_of_rooms = trip.number_of_rooms
			@booking.number_of_adults = trip.number_of_adults
			@booking.number_of_children_between_5_and_12_years = trip.number_of_children_between_5_and_12_years
			@booking.number_of_children_below_5_years = trip.number_of_children_below_5_years
			@booking.number_of_drivers = trip.number_of_drivers
			@booking.guests_food_preferences = trip.food_preferences
			@booking.comments = trip.comments
		end

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

    respond_to do |format|
      if @booking.update_attributes(params[:booking])
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

    respond_to do |format|
      format.html { redirect_to bookings_url }
      format.json { head :ok }
    end
  end
end

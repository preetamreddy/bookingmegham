class TaxiBookingsController < ApplicationController
  # GET /taxi_bookings
  # GET /taxi_bookings.json
  def index
		if params[:trip_id]
			trip_id = params[:trip_id].to_i
			if Trip.find_all_by_id(trip_id).any?
				session[:trip_id] = trip_id
				session[:guest_id] = Trip.find(session[:trip_id]).guest_id
			end
		end

		if session[:trip_id]
			@taxi_bookings = TaxiBooking.paginate(page: params[:page], per_page: 5).
													find_all_by_trip_id(session[:trip_id])
		else
    	@taxi_bookings = TaxiBooking.paginate(page: params[:page], per_page: 5).
													all
		end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @taxi_bookings }
    end
  end

  # GET /taxi_bookings/1
  # GET /taxi_bookings/1.json
  def show
		begin
    	@taxi_booking = TaxiBooking.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			logger.error "Attempt to access invalid taxi booking #{params[:id]}"
			redirect_to taxi_bookings_url, alert: 'Invalid taxi booking'
		else
    	respond_to do |format|
      	format.html # show.html.erb
      	format.json { render json: @taxi_booking }
			end
    end
  end

  # GET /taxi_bookings/new
  # GET /taxi_bookings/new.json
  def new
    @taxi_booking = TaxiBooking.new

		if session[:trip_id]
			@taxi_booking.trip_id = session[:trip_id]
		end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @taxi_booking }
    end
  end

  # GET /taxi_bookings/1/edit
  def edit
		begin
    	@taxi_booking = TaxiBooking.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			logger.error "Attempt to access invalid taxi booking #{params[:id]}"
			redirect_to taxi_bookings_url, alert: 'Invalid taxi booking'
		end
  end

  # POST /taxi_bookings
  # POST /taxi_bookings.json
  def create
    @taxi_booking = TaxiBooking.new(params[:taxi_booking])
		trip = Trip.find(@taxi_booking.trip_id)

    respond_to do |format|
      if @taxi_booking.save
				trip.save

        format.html { redirect_to @taxi_booking, notice: 'Taxi booking was successfully created.' }
        format.json { render json: @taxi_booking, status: :created, location: @taxi_booking }
      else
        format.html { render action: "new" }
        format.json { render json: @taxi_booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /taxi_bookings/1
  # PUT /taxi_bookings/1.json
  def update
    @taxi_booking = TaxiBooking.find(params[:id])

    respond_to do |format|
      if @taxi_booking.update_attributes(params[:taxi_booking])
        format.html { redirect_to @taxi_booking, notice: 'Taxi booking was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @taxi_booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /taxi_bookings/1
  # DELETE /taxi_bookings/1.json
  def destroy
    @taxi_booking = TaxiBooking.find(params[:id])
    @taxi_booking.destroy

    respond_to do |format|
      format.html { redirect_to taxi_bookings_url, alert: @taxi_booking.errors[:base][0] }
      format.json { head :ok }
    end
  end

	def email
		taxi_booking = TaxiBooking.find(params[:taxi_booking_id])
		TaxiBookingNotifier.details(taxi_booking).deliver

		respond_to do |format|
			format.html { redirect_to taxi_booking, notice: 'Email was successfully sent.' }
      format.json { render json: @taxi_booking, status: :sent, location: @taxi_booking }
		end
	end
end

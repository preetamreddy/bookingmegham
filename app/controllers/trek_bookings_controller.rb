class TrekBookingsController < ApplicationController
  # GET /trek_bookings
  # GET /trek_bookings.json
  def index
		if params[:trip_id]
			trip_id = params[:trip_id].to_i
			if Trip.find_all_by_id(trip_id).any?
				session[:trip_id] = trip_id
				session[:guest_id] = Trip.find(session[:trip_id]).guest_id
			end
		end

		if session[:trip_id]
			@trek_bookings = TrekBooking.find_all_by_trip_id(session[:trip_id])
		else
			@trek_bookings = TrekBooking.paginate(page: params[:page], per_page: 5).
													all
		end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trek_bookings }
    end
  end

  # GET /trek_bookings/1
  # GET /trek_bookings/1.json
  def show
		begin
			@trek_booking = TrekBooking.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			logger.error "Attempt to access invalid trek booking #{params[:id]}"
			redirect_to trek_bookings_url, notice: 'Invalid Trek Booking'
		else
    	respond_to do |format|
      	format.html # show.html.erb
      	format.json { render json: @trek_booking }
			end
    end
  end

  # GET /trek_bookings/new
  # GET /trek_bookings/new.json
  def new
		@trek_booking = TrekBooking.new

		if session[:trip_id]
			@trek_booking.trip_id = session[:trip_id]
		end

   	respond_to do |format|
     	format.html # new.html.erb
     	format.json { render json: @trek_booking }
   	end
  end

  # GET /trek_bookings/1/edit
  def edit
		begin
    	@trek_booking = TrekBooking.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			logger.error "Attempt to access invalid trek booking #{params[:id]}"
			redirect_to trek_bookings_url, notice: 'Invalid Trek Booking'
		end
  end

  # POST /trek_bookings
  # POST /trek_bookings.json
  def create
    @trek_booking = TrekBooking.new(params[:trek_booking])

    respond_to do |format|
      if @trek_booking.save
        format.html { redirect_to @trek_booking, notice: 'Trek booking was successfully created.' }
        format.json { render json: @trek_booking, status: :created, location: @trek_booking }
      else
        format.html { render action: "new" }
        format.json { render json: @trek_booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trek_bookings/1
  # PUT /trek_bookings/1.json
  def update
    @trek_booking = TrekBooking.find(params[:id])

    respond_to do |format|
      if @trek_booking.update_attributes(params[:trek_booking])
        format.html { redirect_to @trek_booking, notice: 'Trek booking was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @trek_booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trek_bookings/1
  # DELETE /trek_bookings/1.json
  def destroy
    @trek_booking = TrekBooking.find(params[:id])
    @trek_booking.destroy

    respond_to do |format|
      format.html { redirect_to trek_bookings_url, notice: @trek_booking.errors[:base][0] }
      format.json { head :ok }
    end
  end
end

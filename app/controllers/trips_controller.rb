class TripsController < ApplicationController
  # GET /trips
  # GET /trips.json
  def index
		if params[:guest_id]
			guest_id = params[:guest_id].to_i
			if Guest.find_all_by_id(guest_id).any?
				session[:guest_id] = guest_id
				session[:trip_id] = nil
			end
		end

		if session[:guest_id]
			@trips = Trip.paginate(page: params[:page], per_page: 5).
								order("start_date DESC, end_date DESC").
								find_all_by_guest_id(session[:guest_id])
		else
			if params[:payment_status]
    		@trips = Trip.paginate(page: params[:page], per_page: 5).
									order("pay_by_date ASC, start_date DESC, end_date DESC").
									find_all_by_payment_status(params[:payment_status])
			elsif params[:payment_overdue]
    		@trips = Trip.paginate(page: params[:page], per_page: 5).
									order('pay_by_date ASC, start_date DESC, end_date DESC').
									find(:all, :conditions => [
										'payment_status != ? and pay_by_date < ?',
										Trip::FULLY_PAID, Date.today ])
			else
    		@trips = Trip.paginate(page: params[:page], per_page: 5).
									order("start_date DESC, end_date DESC").all
			end
		end

		@records_returned = @trips.count

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trips }
    end
  end

  # GET /trips/1
  # GET /trips/1.json
  def show
		begin
    	@trip = Trip.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			logger.error "Attempt to access invalid trip #{params[:id]}"
			redirect_to trips_url, notice: 'Invalid Trip'
		else
    	respond_to do |format|
      	format.html # show.html.erb
      	format.json { render json: @trip }
			end
    end
  end

  # GET /trips/new
  # GET /trips/new.json
  def new
		if (params[:guest_id])
			session[:guest_id] = params[:guest_id].to_i
		end

    @trip = Trip.new
		@trip.rooms.build
		@trip.guest_id = session[:guest_id]

		if session[:guest_id]
			@trip.agency_id = Guest.find(session[:guest_id]).agency_id
		end

		if !@trip.agency_id
			@trip.direct_booking = 1
			@trip.agency_id = User.find_by_id(session[:user_id]).agency_id
		else
			@trip.direct_booking = 0
		end

		@trip.advisor_id = User.find_by_id(session[:user_id]).advisor_id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trip }
    end
  end

  # GET /trips/1/edit
  def edit
		begin
    	@trip = Trip.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			logger.error "Attempt to access invalid trip #{params[:id]}"
			redirect_to trips_url, notice: 'Invalid Trip'
		end
  end

  # POST /trips
  # POST /trips.json
  def create
    @trip = Trip.new(params[:trip])

    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip, notice: 'Trip was successfully created.' }
        format.json { render json: @trip, status: :created, location: @trip }
      else
        format.html { render action: "new" }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trips/1
  # PUT /trips/1.json
  def update
    @trip = Trip.find(params[:id])

    respond_to do |format|
      if @trip.update_attributes(params[:trip])
				@trip.save

        format.html { redirect_to @trip, notice: 'Trip was successfully updated.' }
        format.json { head :ok }
			else
       	format.html { render action: "edit" }
       	format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.json
  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy

		if session[:trip_id] == params[:id].to_i
			session[:trip_id] = nil
		end

    respond_to do |format|
      format.html { redirect_to trips_url, notice: @trip.errors[:base][0] }
      format.json { head :ok }
    end
  end

	def email
		trip = Trip.find(params[:trip_id])
		if params[:type] == 'itinerary'
			TripNotifier.itinerary(trip, session[:user_id]).deliver
		elsif params[:type] == 'invoice'
			TripNotifier.invoice(trip, session[:user_id]).deliver
		elsif params[:type] == 'vouchers'
			TripNotifier.vouchers(trip, session[:user_id]).deliver
		end

		respond_to do |format|
			format.html { redirect_to trip, notice: 'Email was successfully sent.' }
      format.json { render json: @trip, status: :sent, location: @trip }
		end
	end
end

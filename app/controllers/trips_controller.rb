class TripsController < ApplicationController
	load_and_authorize_resource

  # GET /trips
  # GET /trips.json
  def index
		if params[:guest_id]
			guest_id = params[:guest_id].to_i
			if Guest.scoped_by_account_id(current_user.account_id).find_all_by_id(guest_id).any?
				session[:guest_id] = guest_id
				session[:trip_id] = nil
			end
		end

		if session[:guest_id]
			@trips = @trips.paginate(page: params[:page], per_page: 10).
								order("start_date DESC, end_date DESC").
								find_all_by_guest_id(session[:guest_id])
		else
			if params[:payment_status]
    		@trips = @trips.paginate(page: params[:page], per_page: 10).
									order("pay_by_date ASC, start_date DESC, end_date DESC").
									find_all_by_payment_status(params[:payment_status])
			elsif params[:payment_overdue]
    		@trips = @trips.paginate(page: params[:page], per_page: 10).
									order('pay_by_date ASC, start_date DESC, end_date DESC').
									find(:all, :conditions => [
										'payment_status != ? and pay_by_date < ?',
										Trip::FULLY_PAID, Date.today ])
			else
    		@trips = @trips.paginate(page: params[:page], per_page: 10).
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
   	respond_to do |format|
     	format.html # show.html.erb
     	format.json { render json: @trip }
    end
  end

  # GET /trips/new
  # GET /trips/new.json
  def new
		if (params[:guest_id])
			session[:guest_id] = params[:guest_id].to_i
		end

		@trip.trip_rooms.build
		@trip.guest_id = session[:guest_id]

		if session[:guest_id]
			guest = Guest.scoped_by_account_id(current_user.account_id).find(session[:guest_id])
			@trip.agency_id = guest.agency_id
			@trip.remarks = guest.other_information
		end

		if !@trip.agency_id
			@trip.direct_booking = 1
			@trip.agency_id = current_user.agency.id
		else
			@trip.direct_booking = 0
		end

		@trip.advisor_id = current_user.advisor_id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trip }
    end
  end

  # GET /trips/1/edit
  def edit
  end

  # POST /trips
  # POST /trips.json
  def create
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
    respond_to do |format|
      if @trip.update_attributes(params[:trip])
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
    @trip.destroy

		if session[:trip_id] == params[:id].to_i
			session[:trip_id] = nil
		end

    respond_to do |format|
      format.html { redirect_to trips_url, alert: @trip.errors[:base][0] }
      format.json { head :ok }
    end
  end

	def email
		trip = Trip.scoped_by_account_id(current_user.account_id).find(params[:trip_id])
		if params[:type] == 'itinerary'
			TripNotifier.itinerary(trip, current_user.id).deliver
		elsif params[:type] == 'invoice'
			TripNotifier.invoice(trip, current_user.id).deliver
		elsif params[:type] == 'vouchers'
			TripNotifier.vouchers(trip, current_user.id).deliver
		end

		respond_to do |format|
			format.html { redirect_to trip, notice: 'Email was successfully sent.' }
      format.json { render json: trip, status: :sent, location: trip }
		end
	end
end

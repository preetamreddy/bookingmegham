class TripsController < ApplicationController
  # GET /trips
  # GET /trips.json
  def index
		if params[:guest_id]
			session[:guest_id] = params[:guest_id].to_i
			session[:trip_id] = nil
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
										'Fully Paid', Date.today ])
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
    @trip = Trip.find(params[:id])

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

    @trip = Trip.new
		@trip.rooms.build
		@trip.guest_id = session[:guest_id]
		@trip.agency_id = User.find_by_id(session[:user_id]).agency_id
		@trip.advisor_id = User.find_by_id(session[:user_id]).advisor_id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trip }
    end
  end

  # GET /trips/1/edit
  def edit
    @trip = Trip.find(params[:id])
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
		if params[:type] == 'details'
			TripNotifier.details(trip).deliver
		elsif params[:type] == 'invoice'
			TripNotifier.invoice(trip).deliver
		elsif params[:type] == 'receipt'
			TripNotifier.receipt(trip).deliver
		elsif params[:type] == 'voucher'
			TripNotifier.voucher(trip).deliver
		end

		respond_to do |format|
			format.html { redirect_to trip, notice: 'Email was successfully sent.' }
      format.json { render json: @trip, status: :sent, location: @trip }
		end
	end
end

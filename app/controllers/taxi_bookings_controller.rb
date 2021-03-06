class TaxiBookingsController < ApplicationController
	load_and_authorize_resource

  # GET /taxi_bookings
  # GET /taxi_bookings.json
  def index
		if params[:trip_id]
      store_trip_in_session(params[:trip_id].to_i)
		end

		if params[:from_date]
			@from_date = params[:from_date].to_date
		else
			@from_date = Date.today
		end

    if params[:to_date]
      @to_date = params[:to_date].to_date
		else
      @to_date = Date.today + 7
		end

		if session[:trip_id]
			@taxi_bookings = @taxi_bookings.paginate(page: params[:page], per_page: 10).
        order("start_date desc, end_date desc").find_all_by_trip_id(session[:trip_id])
		elsif session[:customer_id]
			trips = Trip.scoped_by_account_id(current_user.account_id).
        find(:all, :conditions => [ 'customer_type = ? and customer_id = ?',
          session[:customer_type], session[:customer_id] ])
			@taxi_bookings = @taxi_bookings.paginate(page: params[:page], per_page: 10).
        order("start_date desc, end_date desc").find_all_by_trip_id(trips)
		else
			@taxi_bookings = @taxi_bookings.paginate(page: params[:page], per_page: 10).
        order("start_date asc, end_date asc").
				find(:all, :conditions => [ 'start_date >= ? and start_date < ?',
					@from_date, @to_date ])
		end

    if session[:trip_id]
      trip = Trip.scoped_by_account_id(current_user.account_id).find(session[:trip_id])
      @trip_name = trip.name
      @customer_name = trip.customer.name
    elsif session[:customer_id]
      customer = session[:customer_type].classify.constantize.
        scoped_by_account_id(current_user.account_id).find(session[:customer_id])
      @customer_name = customer.name
    end

		@records_returned = @taxi_bookings.count

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @taxi_bookings }
    end
  end

  # GET /taxi_bookings/1
  # GET /taxi_bookings/1.json
  def show
    respond_to do |format|
     	format.html # show.html.erb
     	format.json { render json: @taxi_booking }
    end
  end

  # GET /taxi_bookings/new
  # GET /taxi_bookings/new.json
  def new
		if params[:trip_id]
      store_trip_in_session(params[:trip_id].to_i)
		end

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
  end

  # POST /taxi_bookings
  # POST /taxi_bookings.json
  def create
    respond_to do |format|
      if @taxi_booking.save
        store_trip_in_session(@taxi_booking.trip_id)

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
    respond_to do |format|
      if @taxi_booking.update_attributes(params[:taxi_booking])
        store_trip_in_session(@taxi_booking.trip_id)

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
    @taxi_booking.destroy

    respond_to do |format|
      format.html { redirect_to :back, alert: @taxi_booking.errors[:base][0] }
      format.json { head :ok }
    end
  end

	def email
		taxi_booking = TaxiBooking.scoped_by_account_id(current_user.account_id).find(params[:taxi_booking_id])
		TaxiBookingNotifier.details(taxi_booking).deliver

		respond_to do |format|
			format.html { redirect_to taxi_booking, notice: 'Email was successfully sent.' }
      format.json { render json: @taxi_booking, status: :sent, location: @taxi_booking }
		end
	end
end

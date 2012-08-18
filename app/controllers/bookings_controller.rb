class BookingsController < ApplicationController
	load_and_authorize_resource

  # GET /bookings
  # GET /bookings.json
  def index
		if params[:trip_id]
			trip_id = params[:trip_id].to_i
			if Trip.scoped_by_account_id(current_user.account_id).find_all_by_id(trip_id).any?
				session[:trip_id] = trip_id
				session[:guest_id] = Trip.scoped_by_account_id(current_user.account_id).find(trip_id).guest_id
			end
		end
			
		if params[:property_id]
			@property_id = params[:property_id].to_i
		else
			@property_id = 0
		end

		if params[:check_in_date_first]
			@check_in_date_first = Date.civil(
															params[:check_in_date_first][:year].to_i,
															params[:check_in_date_first][:month].to_i,
															params[:check_in_date_first][:day].to_i)
		else
			@check_in_date_first = Date.today
		end

		if params[:number_of_days]
			@number_of_days = params[:number_of_days].to_i
		else
			@number_of_days = 7
		end

		@check_in_date_last = @check_in_date_first + @number_of_days

		if session[:trip_id]
			@bookings = @bookings.paginate(page: params[:page], per_page: 10).
										order("check_in_date, check_out_date").
										find_all_by_trip_id(session[:trip_id])
		elsif session[:guest_id]
			trips = Trip.scoped_by_account_id(current_user.account_id).find_all_by_guest_id(session[:guest_id])
			@bookings = @bookings.paginate(page: params[:page], per_page: 10).
										order("check_in_date, check_out_date").
										find_all_by_trip_id(trips)
		else
			if @property_id > 0
				@bookings = @bookings.paginate(page: params[:page], per_page: 10).
											order("check_in_date, check_out_date").
											find(:all, :conditions => [
												'property_id = ? and check_in_date >= ? and
												check_in_date < ?',
												@property_id, @check_in_date_first,
												@check_in_date_last ])
			else
				@bookings = @bookings.paginate(page: params[:page], per_page: 10).
											order("check_in_date, check_out_date").
											find(:all, :conditions => [
												'check_in_date >= ? and check_in_date < ?',
												@check_in_date_first, @check_in_date_last ])
			end
		end

		@records_returned = @bookings.count

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bookings }
    end
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
    respond_to do |format|
     	format.html # show.html.erb
     	format.json { render json: @booking }
    end
  end

  # GET /bookings/new
  # GET /bookings/new.json
  def new
		if params[:property_id]
			@booking.property_id = params[:property_id]
		else
      @properties = Property.scoped_by_account_id(current_user.account_id).
        order('ensure_availability_before_booking desc, name').all
		end
		
		if session[:trip_id]	
			trip = Trip.scoped_by_account_id(current_user.account_id).find(session[:trip_id])

			@booking.trip_id = session[:trip_id]
			@booking.remarks = trip.remarks
			@booking.add_rooms_from_trip(trip)
		end

    respond_to do |format|
      format.html # new.html.erb
			format.js
      format.json { render json: @booking }
    end
  end

  # GET /bookings/1/edit
  def edit
		if params[:cancel_booking].to_i == 1
			@cancel_booking = params[:cancel_booking].to_i
		else
			@cancel_booking = 0
		end
  end

  # POST /bookings
  # POST /bookings.json
  def create
		@booking.rooms.each do |room|
			room.check_in_date = @booking.check_in_date
			room.number_of_nights = @booking.number_of_nights
		end

    respond_to do |format|
      if @booking.save
        format.html { redirect_to @booking, notice: 'Booking was successfully created.' }
				format.js { render :js => "window.location.replace('#{booking_url(@booking)}');" }
        format.json { render json: @booking, status: :created, location: @booking }
      else
        format.html { render action: "new" }
				format.js {render action: "new" }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bookings/1
  # PUT /bookings/1.json
  def update
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
    @booking.destroy

    respond_to do |format|
      format.html { redirect_to bookings_url, alert: @booking.errors[:base][0] }
      format.json { head :ok }
    end
  end
end

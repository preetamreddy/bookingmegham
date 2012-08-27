class BookingsController < ApplicationController
	load_and_authorize_resource

  # GET /bookings
  # GET /bookings.json
  def index
		if params[:trip_id]
      store_trip_in_session(params[:trip_id].to_i)
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
		elsif session[:customer_id]
			trips = Trip.scoped_by_account_id(current_user.account_id).
        find(:all, :conditions => [
             'customer_type = ? and customer_id = ?',
             session[:customer_type], session[:customer_id] ])
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
		if params[:trip_id]
      store_trip_in_session(params[:trip_id].to_i)
		end

    room_type = find_room_type
    property = room_type ? room_type.property : find_property 

    if session[:trip_id]
			if property
				@booking.property_id = property.id
			
				trip = Trip.scoped_by_account_id(current_user.account_id).find(session[:trip_id])
				@booking.trip_id = trip.id
				@booking.add_rooms_from_trip(trip)

        if params[:check_in_date]
          @booking.check_in_date = Date.strptime(params[:check_in_date], "%Y-%m-%d")
        end

        if room_type
          @booking.rooms.each do |room|
            room.room_type_id = room_type.id
          end	
        end

	      respond_to do |format|
	        format.html # new.html.erb
	        format.json { render json: @booking }
	      end
			else
	      @properties = Property.scoped_by_account_id(current_user.account_id).
	        order('ensure_availability_before_booking desc, name').all
			end
    else
      redirect_to bookings_url, 
        alert: 'New bookings can only be created after selecting a trip.'
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

  private
    def store_trip_in_session(trip_id)
			if Trip.scoped_by_account_id(current_user.account_id).find_all_by_id(trip_id).any?
			  trip = Trip.scoped_by_account_id(current_user.account_id).find(trip_id)
			  session[:trip_id] = trip.id
			  session[:customer_type] = trip.customer_type
			  session[:customer_id] = trip.customer_id
      end
    end

    def find_property
      if Property.scoped_by_account_id(current_user.account_id).find_all_by_id(params[:property_id].to_i).any?
	      Property.find(params[:property_id].to_i) 
      else
        nil
      end
    end

    def find_room_type
      if RoomType.scoped_by_account_id(current_user.account_id).find_all_by_id(params[:room_type_id].to_i).any?
	      RoomType.find(params[:room_type_id].to_i)
      else
        nil
      end
    end
end

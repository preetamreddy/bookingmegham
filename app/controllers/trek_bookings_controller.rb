class TrekBookingsController < ApplicationController
	load_and_authorize_resource

  # GET /trek_bookings
  # GET /trek_bookings.json
  def index
		if params[:trip_id]
			trip_id = params[:trip_id].to_i
			if Trip.scoped_by_account_id(current_user.account_id).find_all_by_id(trip_id).any?
				session[:trip_id] = trip_id
				session[:guest_id] = Trip.scoped_by_account_id(current_user.account_id).find(trip_id).guest_id
			end
		end

		if session[:trip_id]
			@trek_bookings = @trek_bookings.paginate(page: params[:page], per_page: 5).
													find_all_by_trip_id(session[:trip_id])
		else
			@trek_bookings = @trek_bookings.paginate(page: params[:page], per_page: 5)
		end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trek_bookings }
    end
  end

  # GET /trek_bookings/1
  # GET /trek_bookings/1.json
  def show
    respond_to do |format|
     	format.html # show.html.erb
     	format.json { render json: @trek_booking }
    end
  end

  # GET /trek_bookings/new
  # GET /trek_bookings/new.json
  def new
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
  end

  # POST /trek_bookings
  # POST /trek_bookings.json
  def create
		trip = Trip.scoped_by_account_id(current_user.account_id).find(@trek_booking.trip_id)

    respond_to do |format|
      if @trek_booking.save
				trip.save

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
    @trek_booking.destroy

    respond_to do |format|
      format.html { redirect_to trek_bookings_url, alert: @trek_booking.errors[:base][0] }
      format.json { head :ok }
    end
  end
end

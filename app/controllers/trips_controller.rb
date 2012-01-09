class TripsController < ApplicationController
  # GET /trips
  # GET /trips.json
  def index
		if params[:guest_id]
			session[:guest_id] = params[:guest_id]
		end

		if session[:guest_id]
			@trips = Trip.order("start_date DESC, end_date DESC").find_all_by_guest_id(session[:guest_id])
		else
    	@trips = Trip.order("start_date DESC, end_date DESC").all
		end

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
			session[:guest_id] = params[:guest_id]
		end

    @trip = Trip.new
		@trip.rooms.build
		@trip.guest_id = session[:guest_id]

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

		if session[:trip_id] == params[:id]
			session[:trip_id] = nil
		end

    respond_to do |format|
      format.html { redirect_to trips_url, notice: @trip.errors[:base][0] }
      format.json { head :ok }
    end
  end
end

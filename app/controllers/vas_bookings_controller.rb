class VasBookingsController < ApplicationController
  # GET /vas_bookings
  # GET /vas_bookings.json
  def index
    @vas_bookings = VasBooking.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vas_bookings }
    end
  end

  # GET /vas_bookings/1
  # GET /vas_bookings/1.json
  def show
    @vas_booking = VasBooking.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vas_booking }
    end
  end

  # GET /vas_bookings/new
  # GET /vas_bookings/new.json
  def new
    @vas_booking = VasBooking.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vas_booking }
    end
  end

  # GET /vas_bookings/1/edit
  def edit
    @vas_booking = VasBooking.find(params[:id])
  end

  # POST /vas_bookings
  # POST /vas_bookings.json
  def create
    @vas_booking = VasBooking.new(params[:vas_booking])

    respond_to do |format|
      if @vas_booking.save
        format.html { redirect_to @vas_booking, notice: 'Vas booking was successfully created.' }
        format.json { render json: @vas_booking, status: :created, location: @vas_booking }
      else
        format.html { render action: "new" }
        format.json { render json: @vas_booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vas_bookings/1
  # PUT /vas_bookings/1.json
  def update
    @vas_booking = VasBooking.find(params[:id])

    respond_to do |format|
      if @vas_booking.update_attributes(params[:vas_booking])
        format.html { redirect_to @vas_booking, notice: 'Vas booking was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @vas_booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vas_bookings/1
  # DELETE /vas_bookings/1.json
  def destroy
    @vas_booking = VasBooking.find(params[:id])
    @vas_booking.destroy

    respond_to do |format|
      format.html { redirect_to vas_bookings_url }
      format.json { head :ok }
    end
  end
end

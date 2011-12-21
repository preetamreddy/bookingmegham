class BookedRoomsController < ApplicationController
  # GET /booked_rooms
  # GET /booked_rooms.json
  def index
    @booked_rooms = BookedRoom.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @booked_rooms }
    end
  end

  # GET /booked_rooms/1
  # GET /booked_rooms/1.json
  def show
    @booked_room = BookedRoom.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @booked_room }
    end
  end

  # GET /booked_rooms/new
  # GET /booked_rooms/new.json
  def new
    @booked_room = BookedRoom.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @booked_room }
    end
  end

  # GET /booked_rooms/1/edit
  def edit
    @booked_room = BookedRoom.find(params[:id])
  end

  # POST /booked_rooms
  # POST /booked_rooms.json
  def create
    @booked_room = BookedRoom.new(params[:booked_room])

    respond_to do |format|
      if @booked_room.save
        format.html { redirect_to @booked_room, notice: 'Booked room was successfully created.' }
        format.json { render json: @booked_room, status: :created, location: @booked_room }
      else
        format.html { render action: "new" }
        format.json { render json: @booked_room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /booked_rooms/1
  # PUT /booked_rooms/1.json
  def update
    @booked_room = BookedRoom.find(params[:id])

    respond_to do |format|
      if @booked_room.update_attributes(params[:booked_room])
        format.html { redirect_to @booked_room, notice: 'Booked room was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @booked_room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /booked_rooms/1
  # DELETE /booked_rooms/1.json
  def destroy
    @booked_room = BookedRoom.find(params[:id])
    @booked_room.destroy

    respond_to do |format|
      format.html { redirect_to booked_rooms_url }
      format.json { head :ok }
    end
  end
end

class RoomTypesController < ApplicationController
  # GET /room_types
  # GET /room_types.json
  def index
		if params[:property_id] == 'All'
			session[:property_id] = nil
		elsif params[:property_id]
			property_id = params[:property_id].to_i
			if Property.find_all_by_id(property_id).any?
				session[:property_id] = params[:property_id].to_i
			end
		end	

		if session[:property_id]
			@room_types = RoomType.order(:price_for_double_occupancy).
											find_all_by_property_id(session[:property_id])
		else
    	@room_types = RoomType.order('property_id, price_for_double_occupancy').
											all
		end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @room_types }
    end
  end

  # GET /room_types/1
  # GET /room_types/1.json
  def show
		begin
    	@room_type = RoomType.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			logger.error "Attempt to access invalid room type #{params[:id]}"
			redirect_to room_types_url, alert: 'Invalid room type'
		else
    	respond_to do |format|
      	format.html # show.html.erb
      	format.json { render json: @room_type }
			end
    end
  end

  # GET /room_types/new
  # GET /room_types/new.json
  def new
    @room_type = RoomType.new
		@room_type.property_id = session[:property_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @room_type }
    end
  end

  # GET /room_types/1/edit
  def edit
		begin
    	@room_type = RoomType.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			logger.error "Attempt to access invalid room type #{params[:id]}"
			redirect_to room_types_url, alert: 'Invalid room type'
		end
  end

  # POST /room_types
  # POST /room_types.json
  def create
    @room_type = RoomType.new(params[:room_type])

    respond_to do |format|
      if @room_type.save
        format.html { redirect_to @room_type, notice: 'Room type was successfully created.' }
        format.json { render json: @room_type, status: :created, location: @room_type }
      else
        format.html { render action: "new" }
        format.json { render json: @room_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /room_types/1
  # PUT /room_types/1.json
  def update
    @room_type = RoomType.find(params[:id])

    respond_to do |format|
      if @room_type.update_attributes(params[:room_type])
        format.html { redirect_to @room_type, notice: 'Room type was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @room_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /room_types/1
  # DELETE /room_types/1.json
  def destroy
    @room_type = RoomType.find(params[:id])
    @room_type.destroy

    respond_to do |format|
      format.html { redirect_to room_types_url, alert: @room_type.errors[:base][0] }
      format.json { head :ok }
    end
  end
end

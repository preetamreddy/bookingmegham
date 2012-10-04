class RoomTypesController < ApplicationController
	load_and_authorize_resource

  # GET /room_types
  # GET /room_types.json
  def index
    property_id = params[:property_id].to_i

    if property_id != 0
      if Property.scoped_by_account_id(current_user.account_id).find_all_by_id(property_id).any?
        session[:property_id] = property_id
      end
    elsif params[:property_id] == 'All'
      session[:property_id] = nil
    end

    if session[:property_id]
      property = Property.scoped_by_account_id(current_user.account_id).find(session[:property_id])
      @property_name = property.name
    end

    if session[:property_id]
			@room_types = @room_types.paginate(page: params[:page], per_page: 10).
				order('property_id, price_for_double_occupancy').
				find_all_by_property_id(session[:property_id])
		else
			@room_types = @room_types.paginate(page: params[:page], per_page: 10).
				order('property_id, price_for_double_occupancy')
		end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @room_types }
    end
  end

  # GET /room_types/1
  # GET /room_types/1.json
  def show
   	respond_to do |format|
     	format.html # show.html.erb
     	format.json { render json: @room_type }
		end
  end

  # GET /room_types/new
  # GET /room_types/new.json
  def new
		@room_type.property_id = session[:property_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @room_type }
    end
  end

  # GET /room_types/1/edit
  def edit
  end

  # POST /room_types
  # POST /room_types.json
  def create
    respond_to do |format|
      if @room_type.save
        session[:property_id] = @room_type.property_id

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
    respond_to do |format|
      if @room_type.update_attributes(params[:room_type])
        session[:property_id] = @room_type.property_id

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
    @room_type.destroy

    respond_to do |format|
      format.html { redirect_to :back, alert: @room_type.errors[:base][0] }
      format.json { head :ok }
    end
  end
end

class RoomTypesController < ApplicationController
	load_and_authorize_resource
  # GET /room_types
  # GET /room_types.json
  def index
    if params[:property_id]
      if Property.scoped_by_account_id(current_user.account_id).find_all_by_id(params[:property_id].to_i).any?
        session[:property_id] = params[:property_id].to_i
      end
    end

    if session[:property_id]
      property = Property.scoped_by_account_id(current_user.account_id).find(session[:property_id])
      session[:property_name] = property.name
    end

		if params[:property_name]
			property_name = params[:property_name].downcase
		elsif session[:property_name]
			property_name = session[:property_name].downcase
		end

    if session[:property_id]
			@room_types = @room_types.paginate(page: params[:page], per_page: 10).
				order('property_id, price_for_double_occupancy').
				find_all_by_property_id(session[:property_id])
		elsif property_name
			properties = Property.scoped_by_account_id(current_user.account_id).
				find(:all, :conditions => [ 'lower(name) like ?', "%" + property_name + "%" ])

			if properties.count == 1
				session[:property_name] = properties.first.name
			else
				session[:property_name] = nil
			end
	
			@room_types = @room_types.paginate(page: params[:page], per_page: 10).
				order('property_id, price_for_double_occupancy').
				find_all_by_property_id(properties)
		else
			@room_types = @room_types.paginate(page: params[:page], per_page: 10).
				order('property_id, price_for_double_occupancy')

			session[:property_name] = nil
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
		if session[:property_name]
			@room_type.property_id = Property.scoped_by_account_id(current_user.account_id).
				find_by_name(session[:property_name]).id
		end

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
      session[:property_name] = Property.scoped_by_account_id(current_user.account_id).
        find(@room_type.property_id).name
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
      session[:property_name] = Property.scoped_by_account_id(current_user.account_id).
        find(@room_type.property_id).name
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
    @room_type.destroy

    respond_to do |format|
      format.html { redirect_to :back, alert: @room_type.errors[:base][0] }
      format.json { head :ok }
    end
  end
end

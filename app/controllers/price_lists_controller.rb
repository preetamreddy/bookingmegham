class PriceListsController < ApplicationController
  load_and_authorize_resource
  # GET /price_lists
  # GET /price_lists.json
  def index
		if RoomType.scoped_by_account_id(current_user.account_id).
        find_all_by_id(params[:room_type_id].to_i).any?
		  room_type = RoomType.scoped_by_account_id(current_user.account_id).find(params[:room_type_id].to_i)
		  session[:room_type_id] = room_type.id
		  session[:property_id] = room_type.property_id
		elsif Property.scoped_by_account_id(current_user.account_id).
        find_all_by_id(params[:property_id].to_i).any?
			session[:room_type_id] = nil
			session[:property_id] = params[:property_id].to_i
    end

    if params[:meal_plan]
      session[:meal_plan] = params[:meal_plan]
    end

    if session[:room_type_id]
      if session[:meal_plan] != ''
        @price_lists = @price_lists.order('start_date desc, meal_plan asc').
          find_all_by_room_type_id_and_meal_plan(session[:room_type_id], session[:meal_plan])
      else
        @price_lists = @price_lists.order('start_date desc, meal_plan asc').
          find_all_by_room_type_id(session[:room_type_id])
      end
    elsif session[:property_id]
        room_types = Property.scoped_by_account_id(current_user.account_id).
          find(session[:property_id]).room_types.collect {|r| [r.id]}
      if session[:meal_plan] != ''
        @price_lists = @price_lists.order('start_date desc, meal_plan asc').
          find_all_by_room_type_id_and_meal_plan(room_types, session[:meal_plan])
      else
        @price_lists = @price_lists.order('start_date desc, meal_plan asc').
          find_all_by_room_type_id(room_types)
      end
    end

    @property_id = session[:property_id]
    @room_type_id = session[:room_type_id]
    @meal_plan = session[:meal_plan]

    @properties = Property.scoped_by_account_id(current_user.account_id).order('name')

    if session[:property_id]
      @room_types = Property.scoped_by_account_id(current_user.account_id).
        find(session[:property_id]).room_types
    else
      @room_types = []
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @price_lists }
    end
  end

  # GET /price_lists/1
  # GET /price_lists/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @price_list }
    end
  end

  # GET /price_lists/new
  # GET /price_lists/new.json
  def new
    if session[:room_type_id]
      @price_list.room_type_id = session[:room_type_id]
    end

    if session[:meal_plan]
      @price_list.meal_plan = session[:meal_plan]
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @price_list }
    end
  end

  # GET /price_lists/1/edit
  def edit
  end

  # POST /price_lists
  # POST /price_lists.json
  def create
    respond_to do |format|
      if @price_list.save
        format.html { redirect_to @price_list, notice: 'Price list was successfully created.' }
        format.json { render json: @price_list, status: :created, location: @price_list }
      else
        format.html { render action: "new" }
        format.json { render json: @price_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /price_lists/1
  # PUT /price_lists/1.json
  def update
    respond_to do |format|
      if @price_list.update_attributes(params[:price_list])
        format.html { redirect_to @price_list, notice: 'Price list was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @price_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /price_lists/1
  # DELETE /price_lists/1.json
  def destroy
    @price_list.destroy

    respond_to do |format|
      format.html { redirect_to price_lists_url }
      format.json { head :ok }
    end
  end

  private
    def store_room_type_in_session(room_type_id)
			if RoomType.scoped_by_account_id(current_user.account_id).find_all_by_id(room_type_id).any?
			  room_type = RoomType.scoped_by_account_id(current_user.account_id).find(room_type_id)
			  session[:room_type_id] = room_type.id
			  session[:property_id] = room_type.property_id
      else
			  session[:room_type_id] = nil
			  session[:property_id] = nil
      end
    end
end

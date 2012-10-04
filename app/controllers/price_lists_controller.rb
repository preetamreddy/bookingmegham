class PriceListsController < ApplicationController
  load_and_authorize_resource
  # GET /price_lists
  # GET /price_lists.json
  def index
    property_id = params[:property_id].to_i
    room_type_id = params[:room_type_id].to_i

		if room_type_id != 0 and RoomType.scoped_by_account_id(current_user.account_id).find_all_by_id(room_type_id).any?
      room_type = RoomType.scoped_by_account_id(current_user.account_id).find(room_type_id)
		  @room_type_id = room_type.id
      @heading = room_type.long_name
		  @property_id = room_type.property_id
		elsif property_id != 0 and Property.scoped_by_account_id(current_user.account_id).find_all_by_id(property_id).any?
      property = Property.scoped_by_account_id(current_user.account_id).find(property_id)
			@room_type_id = nil
			@property_id = property.id
      @heading = property.name
    end

    @meal_plan = params[:meal_plan].to_s
    if params[:for_date]
      @for_date = params[:for_date].to_date
    else
      @for_date = nil
    end

    if @room_type_id
      if @for_date
        @price_lists = @price_lists.order('start_date desc, meal_plan asc').
          where("room_type_id = :room_type_id and
                  meal_plan like :meal_plan and start_date <= :date and end_date >= :date",
            {:meal_plan => "%" + @meal_plan + "%", :date => @for_date, :room_type_id => @room_type_id})
      else
        @price_lists = @price_lists.order('start_date desc, meal_plan asc').
          where("room_type_id = :room_type_id and meal_plan like :meal_plan",
            {:meal_plan => "%" + @meal_plan + "%", :room_type_id => @room_type_id})
      end
    elsif @property_id
      room_types = Property.scoped_by_account_id(current_user.account_id).
        find(@property_id).room_types.collect {|r| [r.id]}
      if @for_date
        @price_lists = @price_lists.order('room_type_id asc, start_date desc, meal_plan asc').
          where("meal_plan like :meal_plan and start_date <= :date and end_date >= :date",
            {:meal_plan => "%" + @meal_plan + "%", :date => @for_date}).
          find_all_by_room_type_id(room_types)
      else
        @price_lists = @price_lists.order('room_type_id asc, start_date desc, meal_plan asc').
          where("meal_plan like :meal_plan", {:meal_plan => "%" + @meal_plan + "%"}).
          find_all_by_room_type_id(room_types)
      end
    else
      if @for_date
        @price_lists = @price_lists.order('room_type_id asc, start_date desc, meal_plan asc').
          where("meal_plan like :meal_plan and start_date <= :date and end_date >= :date",
            {:meal_plan => "%" + @meal_plan + "%", :date => @for_date}).
          find(:all)
      else
        @price_lists = @price_lists.order('room_type_id asc, start_date desc, meal_plan asc').
          where("meal_plan like :meal_plan", {:meal_plan => "%" + @meal_plan + "%"}).find(:all)
      end
    end

    if @meal_plan != ''
      @heading = @heading ? (@heading + ", " + @meal_plan) : @meal_plan
    end
    if @for_date
      @heading = @heading ? (@heading + ", " + @for_date.to_s(:ddmonyy)) : @for_date.to_s(:ddmonyy)
    end

    @properties = Property.scoped_by_account_id(current_user.account_id).order('name')

    if @property_id
      @room_types = Property.scoped_by_account_id(current_user.account_id).
        find(@property_id).room_types
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
    if params[:room_type_id]
      @price_list.room_type_id = params[:room_type_id]
    end

    if params[:meal_plan]
      @price_list.meal_plan = params[:meal_plan]
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
      format.html { redirect_to price_lists_url(
        :room_type_id => @price_list.room_type_id, :meal_plan => @price_list.meal_plan) }
      format.json { head :ok }
    end
  end
end

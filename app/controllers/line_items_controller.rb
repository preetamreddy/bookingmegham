class LineItemsController < ApplicationController
  # GET /line_items
  # GET /line_items.json
  def index
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
			@number_of_days = 1
		end

		@check_in_date_last = @check_in_date_first + @number_of_days

		if @property_id > 0
			@room_types = RoomType.find_all_by_property_id(@property_id)
			@line_items = LineItem.order("date, room_type_id, booking_id").
				find(:all, :conditions => [
					'room_type_id in (?) and date >= ? and
					date < ?',
					@room_types, @check_in_date_first,
					@check_in_date_last ])
		else
			@line_items = LineItem.order("date, room_type_id, booking_id").
				find(:all, :conditions => [
					'date >= ? and date < ?',
					@check_in_date_first, @check_in_date_last ])
		end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @line_items }
    end
  end

  # GET /line_items/1
  # GET /line_items/1.json
  def show
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/new
  # GET /line_items/new.json
  def new
    @line_item = LineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @line_item }
    end
  end

  # GET /line_items/1/edit
  def edit
    @line_item = LineItem.find(params[:id])
  end

  # POST /line_items
  # POST /line_items.json
  def create
    @line_item = LineItem.new(params[:line_item])

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to @line_item, notice: 'Line item was successfully created.' }
        format.json { render json: @line_item, status: :created, location: @line_item }
      else
        format.html { render action: "new" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /line_items/1
  # PUT /line_items/1.json
  def update
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      if @line_item.update_attributes(params[:line_item])
        format.html { redirect_to @line_item, notice: 'Line item was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @line_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.json
  def destroy
    @line_item = LineItem.find(params[:id])
    @line_item.destroy

    respond_to do |format|
      format.html { redirect_to line_items_url }
      format.json { head :ok }
    end
  end
end

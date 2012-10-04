class TaxisController < ApplicationController
	load_and_authorize_resource
  # GET /taxis
  # GET /taxis.json
  def index
    taxi_operator_id = params[:taxi_operator_id].to_i

    if taxi_operator_id != 0
      if Agency.scoped_by_account_id(current_user.account_id).find_all_by_id(taxi_operator_id).any?
        session[:taxi_operator_id] = taxi_operator_id
      end
    elsif params[:taxi_operator_id] == 'All'
      session[:taxi_operator_id] = nil
    end

    if session[:taxi_operator_id]
      taxi_operator = Agency.scoped_by_account_id(current_user.account_id).find(session[:taxi_operator_id])
      @taxi_operator_name = taxi_operator.name
    end

    if session[:taxi_operator_id]
			@taxis = @taxis.paginate(page: params[:page], per_page: 10).
        order('agency_id, unit_price').
				find_all_by_agency_id(session[:taxi_operator_id])
		else
			@taxis = @taxis.paginate(page: params[:page], per_page: 10).
        order('agency_id, unit_price')
		end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @taxis }
    end
  end

  # GET /taxis/1
  # GET /taxis/1.json
  def show
    respond_to do |format|
     	format.html # show.html.erb
     	format.json { render json: @taxi }
    end
  end

  # GET /taxis/new
  # GET /taxis/new.json
  def new
    @taxi.agency_id = session[:taxi_operator_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @taxi }
    end
  end

  # GET /taxis/1/edit
  def edit
  end

  # POST /taxis
  # POST /taxis.json
  def create
    respond_to do |format|
      if @taxi.save
        session[:taxi_operator_id] = @taxi.agency_id

        format.html { redirect_to @taxi, notice: 'Taxi was successfully created.' }
        format.json { render json: @taxi, status: :created, location: @taxi }
      else
        format.html { render action: "new" }
        format.json { render json: @taxi.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /taxis/1
  # PUT /taxis/1.json
  def update
    respond_to do |format|
      if @taxi.update_attributes(params[:taxi])
        session[:taxi_operator_id] = @taxi.agency_id

        format.html { redirect_to @taxi, notice: 'Taxi was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @taxi.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /taxis/1
  # DELETE /taxis/1.json
  def destroy
    @taxi.destroy

    respond_to do |format|
      format.html { redirect_to :back, alert: @taxi.errors[:base][0] }
      format.json { head :ok }
    end
  end
end

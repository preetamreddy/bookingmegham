class TaxisController < ApplicationController
	load_and_authorize_resource
  # GET /taxis
  # GET /taxis.json
  def index
		if params[:taxi_operator_name]
			taxi_operator_name = params[:taxi_operator_name].downcase
		elsif session[:taxi_operator_name]
			taxi_operator_name = session[:taxi_operator_name].downcase
		end

		if taxi_operator_name
			taxi_operators = Agency.scoped_by_account_id(current_user.account_id).
				find(:all, :conditions => [ 'lower(name) like ?', "%" + taxi_operator_name + "%" ])

			if taxi_operators.count == 1
				session[:taxi_operator_name] = taxi_operators.first.name
			else
				session[:taxi_operator_name] = nil
			end
	
			@taxis = @taxis.paginate(page: params[:page], per_page: 10).
        order('agency_id, unit_price').
				find_all_by_agency_id(taxi_operators)
		else
			@taxis = @taxis.paginate(page: params[:page], per_page: 10).
        order('agency_id, unit_price')
		
			session[:taxi_operator_name] = nil
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
    if session[:taxi_operator_name]
      @taxi.agency_id = Agency.scoped_by_account_id(current_user.account_id).
        find_by_name(session[:taxi_operator_name]).id
    end

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
        session[:taxi_operator_name] = Agency.scoped_by_account_id(current_user.account_id).
          find(@taxi.agency_id).name
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
        session[:taxi_operator_name] = Agency.scoped_by_account_id(current_user.account_id).
          find(@taxi.agency_id).name
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
      format.html { redirect_to taxis_url, alert: @taxi.errors[:base][0] }
      format.json { head :ok }
    end
  end
end

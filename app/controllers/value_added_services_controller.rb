class ValueAddedServicesController < ApplicationController
  # GET /value_added_services
  # GET /value_added_services.json
  def index
    @value_added_services = ValueAddedService.order("property_id, name").all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @value_added_services }
    end
  end

  # GET /value_added_services/1
  # GET /value_added_services/1.json
  def show
		begin
    	@value_added_service = ValueAddedService.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			logger.error "Attempt to access invalid value added service #{params[:id]}"
			redirect_to value_added_services_url, notice: 'Invalid Value Added Service'
		else
    	respond_to do |format|
      	format.html # show.html.erb
      	format.json { render json: @value_added_service }
			end
    end
  end

  # GET /value_added_services/new
  # GET /value_added_services/new.json
  def new
    @value_added_service = ValueAddedService.new
		@value_added_service.vas_prices.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @value_added_service }
    end
  end

  # GET /value_added_services/1/edit
  def edit
		begin
    	@value_added_service = ValueAddedService.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			logger.error "Attempt to access invalid value added service #{params[:id]}"
			redirect_to value_added_services_url, notice: 'Invalid Value Added Service'
		end
  end

  # POST /value_added_services
  # POST /value_added_services.json
  def create
    @value_added_service = ValueAddedService.new(params[:value_added_service])

    respond_to do |format|
      if @value_added_service.save
        format.html { redirect_to @value_added_service, notice: 'Value added service was successfully created.' }
        format.json { render json: @value_added_service, status: :created, location: @value_added_service }
      else
        format.html { render action: "new" }
        format.json { render json: @value_added_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /value_added_services/1
  # PUT /value_added_services/1.json
  def update
    @value_added_service = ValueAddedService.find(params[:id])

    respond_to do |format|
      if @value_added_service.update_attributes(params[:value_added_service])
        format.html { redirect_to @value_added_service, notice: 'Value added service was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @value_added_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /value_added_services/1
  # DELETE /value_added_services/1.json
  def destroy
    @value_added_service = ValueAddedService.find(params[:id])
    @value_added_service.destroy

    respond_to do |format|
      format.html { redirect_to value_added_services_url, notice: @value_added_service.errors[:base][0] }
      format.json { head :ok }
    end
  end
end

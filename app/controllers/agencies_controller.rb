class AgenciesController < ApplicationController
  # GET /agencies
  # GET /agencies.json
  def index
		session[:agency_id] = nil

    @agencies = Agency.order(:name).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @agencies }
    end
  end

  # GET /agencies/1
  # GET /agencies/1.json
  def show
		begin
    	@agency = Agency.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			logger.error "Attempt to access invalid agency #{params[:id]}"
			redirect_to agencies_url, alert: 'Invalid agency'
		else
    	respond_to do |format|
      	format.html # show.html.erb
      	format.json { render json: @agency }
			end
    end
  end

  # GET /agencies/new
  # GET /agencies/new.json
  def new
    @agency = Agency.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @agency }
    end
  end

  # GET /agencies/1/edit
  def edit
		begin
    	@agency = Agency.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			logger.error "Attempt to access invalid agency #{params[:id]}"
			redirect_to agencies_url, alert: 'Invalid agency'
		end
  end

  # POST /agencies
  # POST /agencies.json
  def create
    @agency = Agency.new(params[:agency])

    respond_to do |format|
      if @agency.save
        format.html { redirect_to @agency, notice: 'Agency was successfully created.' }
        format.json { render json: @agency, status: :created, location: @agency }
      else
        format.html { render action: "new" }
        format.json { render json: @agency.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /agencies/1
  # PUT /agencies/1.json
  def update
    @agency = Agency.find(params[:id])

    respond_to do |format|
      if @agency.update_attributes(params[:agency])
        format.html { redirect_to @agency, notice: 'Agency was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @agency.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /agencies/1
  # DELETE /agencies/1.json
  def destroy
    @agency = Agency.find(params[:id])
    @agency.destroy

    respond_to do |format|
      format.html { redirect_to agencies_url, alert: @agency.errors[:base][0] }
      format.json { head :ok }
    end
  end
end

class TaxisController < ApplicationController
	load_and_authorize_resource
  # GET /taxis
  # GET /taxis.json
  def index
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

class TaxiDetailsController < ApplicationController
  # GET /taxi_details
  # GET /taxi_details.json
  def index
    @taxi_details = TaxiDetail.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @taxi_details }
    end
  end

  # GET /taxi_details/1
  # GET /taxi_details/1.json
  def show
    @taxi_detail = TaxiDetail.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @taxi_detail }
    end
  end

  # GET /taxi_details/new
  # GET /taxi_details/new.json
  def new
    @taxi_detail = TaxiDetail.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @taxi_detail }
    end
  end

  # GET /taxi_details/1/edit
  def edit
    @taxi_detail = TaxiDetail.find(params[:id])
  end

  # POST /taxi_details
  # POST /taxi_details.json
  def create
    @taxi_detail = TaxiDetail.new(params[:taxi_detail])

    respond_to do |format|
      if @taxi_detail.save
        format.html { redirect_to @taxi_detail, notice: 'Taxi detail was successfully created.' }
        format.json { render json: @taxi_detail, status: :created, location: @taxi_detail }
      else
        format.html { render action: "new" }
        format.json { render json: @taxi_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /taxi_details/1
  # PUT /taxi_details/1.json
  def update
    @taxi_detail = TaxiDetail.find(params[:id])

    respond_to do |format|
      if @taxi_detail.update_attributes(params[:taxi_detail])
        format.html { redirect_to @taxi_detail, notice: 'Taxi detail was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @taxi_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /taxi_details/1
  # DELETE /taxi_details/1.json
  def destroy
    @taxi_detail = TaxiDetail.find(params[:id])
    @taxi_detail.destroy

    respond_to do |format|
      format.html { redirect_to taxi_details_url }
      format.json { head :ok }
    end
  end
end

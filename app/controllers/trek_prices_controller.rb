class TrekPricesController < ApplicationController
  # GET /trek_prices
  # GET /trek_prices.json
  def index
    @trek_prices = TrekPrice.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trek_prices }
    end
  end

  # GET /trek_prices/1
  # GET /trek_prices/1.json
  def show
    @trek_price = TrekPrice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @trek_price }
    end
  end

  # GET /trek_prices/new
  # GET /trek_prices/new.json
  def new
    @trek_price = TrekPrice.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trek_price }
    end
  end

  # GET /trek_prices/1/edit
  def edit
    @trek_price = TrekPrice.find(params[:id])
  end

  # POST /trek_prices
  # POST /trek_prices.json
  def create
    @trek_price = TrekPrice.new(params[:trek_price])

    respond_to do |format|
      if @trek_price.save
        format.html { redirect_to @trek_price, notice: 'Trek price was successfully created.' }
        format.json { render json: @trek_price, status: :created, location: @trek_price }
      else
        format.html { render action: "new" }
        format.json { render json: @trek_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trek_prices/1
  # PUT /trek_prices/1.json
  def update
    @trek_price = TrekPrice.find(params[:id])

    respond_to do |format|
      if @trek_price.update_attributes(params[:trek_price])
        format.html { redirect_to @trek_price, notice: 'Trek price was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @trek_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trek_prices/1
  # DELETE /trek_prices/1.json
  def destroy
    @trek_price = TrekPrice.find(params[:id])
    @trek_price.destroy

    respond_to do |format|
      format.html { redirect_to trek_prices_url }
      format.json { head :ok }
    end
  end
end

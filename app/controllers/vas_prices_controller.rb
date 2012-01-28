class VasPricesController < ApplicationController
  # GET /vas_prices
  # GET /vas_prices.json
  def index
    @vas_prices = VasPrice.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vas_prices }
    end
  end

  # GET /vas_prices/1
  # GET /vas_prices/1.json
  def show
    @vas_price = VasPrice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vas_price }
    end
  end

  # GET /vas_prices/new
  # GET /vas_prices/new.json
  def new
    @vas_price = VasPrice.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vas_price }
    end
  end

  # GET /vas_prices/1/edit
  def edit
    @vas_price = VasPrice.find(params[:id])
  end

  # POST /vas_prices
  # POST /vas_prices.json
  def create
    @vas_price = VasPrice.new(params[:vas_price])

    respond_to do |format|
      if @vas_price.save
        format.html { redirect_to @vas_price, notice: 'Vas price was successfully created.' }
        format.json { render json: @vas_price, status: :created, location: @vas_price }
      else
        format.html { render action: "new" }
        format.json { render json: @vas_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vas_prices/1
  # PUT /vas_prices/1.json
  def update
    @vas_price = VasPrice.find(params[:id])

    respond_to do |format|
      if @vas_price.update_attributes(params[:vas_price])
        format.html { redirect_to @vas_price, notice: 'Vas price was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @vas_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vas_prices/1
  # DELETE /vas_prices/1.json
  def destroy
    @vas_price = VasPrice.find(params[:id])
    @vas_price.destroy

    respond_to do |format|
      format.html { redirect_to vas_prices_url }
      format.json { head :ok }
    end
  end
end

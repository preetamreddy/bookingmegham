class TreksController < ApplicationController
  # GET /treks
  # GET /treks.json
  def index
    @treks = Trek.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @treks }
    end
  end

  # GET /treks/1
  # GET /treks/1.json
  def show
		begin
    	@trek = Trek.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			logger.error "Attempt to access invalid trek #{params[:id]}"
			redirect_to treks_url, notice: 'Invalid Trek'
		else
    	respond_to do |format|
      	format.html # show.html.erb
      	format.json { render json: @trek }
			end
    end
  end

  # GET /treks/new
  # GET /treks/new.json
  def new
    @trek = Trek.new

		@trek.trek_prices.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @trek }
    end
  end

  # GET /treks/1/edit
  def edit
		begin
    	@trek = Trek.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			logger.error "Attempt to access invalid trek #{params[:id]}"
			redirect_to treks_url, notice: 'Invalid Trek'
		end
  end

  # POST /treks
  # POST /treks.json
  def create
    @trek = Trek.new(params[:trek])

    respond_to do |format|
      if @trek.save
        format.html { redirect_to @trek, notice: 'Trek was successfully created.' }
        format.json { render json: @trek, status: :created, location: @trek }
      else
        format.html { render action: "new" }
        format.json { render json: @trek.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /treks/1
  # PUT /treks/1.json
  def update
    @trek = Trek.find(params[:id])

    respond_to do |format|
      if @trek.update_attributes(params[:trek])
        format.html { redirect_to @trek, notice: 'Trek was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @trek.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /treks/1
  # DELETE /treks/1.json
  def destroy
    @trek = Trek.find(params[:id])
    @trek.destroy

    respond_to do |format|
      format.html { redirect_to treks_url, notice: @taxi.errors[:base][0] }
      format.json { head :ok }
    end
  end
end

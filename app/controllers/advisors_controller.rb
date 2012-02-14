class AdvisorsController < ApplicationController
  # GET /advisors
  # GET /advisors.json
  def index
		if params[:agency_id] == 'All'
			session[:agency_id] = nil
		elsif params[:agency_id]
			session[:agency_id] = params[:agency_id].to_i
		end

		if session[:agency_id]
    	@advisors = Advisor.order(:name).
										find_all_by_agency_id(session[:agency_id])
		else
    	@advisors = Advisor.order('agency_id, name').all
		end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @advisors }
    end
  end

  # GET /advisors/1
  # GET /advisors/1.json
  def show
    @advisor = Advisor.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @advisor }
    end
  end

  # GET /advisors/new
  # GET /advisors/new.json
  def new
    @advisor = Advisor.new
		@advisor.agency_id = session[:agency_id]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @advisor }
    end
  end

  # GET /advisors/1/edit
  def edit
    @advisor = Advisor.find(params[:id])
  end

  # POST /advisors
  # POST /advisors.json
  def create
    @advisor = Advisor.new(params[:advisor])

    respond_to do |format|
      if @advisor.save
        format.html { redirect_to @advisor, notice: 'Advisor was successfully created.' }
        format.json { render json: @advisor, status: :created, location: @advisor }
      else
        format.html { render action: "new" }
        format.json { render json: @advisor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /advisors/1
  # PUT /advisors/1.json
  def update
    @advisor = Advisor.find(params[:id])

    respond_to do |format|
      if @advisor.update_attributes(params[:advisor])
        format.html { redirect_to @advisor, notice: 'Advisor was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @advisor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /advisors/1
  # DELETE /advisors/1.json
  def destroy
    @advisor = Advisor.find(params[:id])
    @advisor.destroy

    respond_to do |format|
      format.html { redirect_to advisors_url, notice: @advisor.errors[:base][0] }
      format.json { head :ok }
    end
  end
end

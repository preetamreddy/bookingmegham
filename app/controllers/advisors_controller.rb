class AdvisorsController < ApplicationController
	load_and_authorize_resource
  # GET /advisors
  # GET /advisors.json
  def index
    @advisors = @advisors.order('name')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @advisors }
    end
  end

  # GET /advisors/1
  # GET /advisors/1.json
  def show

   	respond_to do |format|
     	format.html # show.html.erb
     	format.json { render json: @advisor }
		end
  end

  # GET /advisors/new
  # GET /advisors/new.json
  def new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @advisor }
    end
  end

  # GET /advisors/1/edit
  def edit
  end

  # POST /advisors
  # POST /advisors.json
  def create

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
    @advisor.destroy

    respond_to do |format|
      format.html { redirect_to advisors_url, alert: @advisor.errors[:base][0] }
      format.json { head :ok }
    end
  end
end

class AgenciesController < ApplicationController
	load_and_authorize_resource

  autocomplete :agency, :name, :full => true

  # GET /agencies
  # GET /agencies.json
  def index
    id = params[:id].to_i

    if id != 0
   	  @agencies = @agencies.paginate(page: params[:page], per_page: 10).order(:name).find_all_by_id(id)
      if @agencies.any?
        @agency_name = @agencies.first.name
      end
    else
   	  @agencies = @agencies.paginate(page: params[:page], per_page: 10).order(:name).find(:all)
    end

		@records_returned = @agencies.count

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @agencies }
    end
  end

  # GET /agencies/1
  # GET /agencies/1.json
  def show
    respond_to do |format|
     	format.html # show.html.erb
     	format.json { render json: @agency }
    end
  end

  # GET /agencies/new
  # GET /agencies/new.json
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @agency }
    end
  end

  # GET /agencies/1/edit
  def edit
  end

  # POST /agencies
  # POST /agencies.json
  def create
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
    @agency.destroy

		if session[:customer_type] == @agency.class.name and session[:customer_id] == params[:id].to_i
			session[:customer_type] = nil
			session[:customer_id] = nil
		end

    respond_to do |format|
      format.html { redirect_to :back, alert: @agency.errors[:base][0] }
      format.json { head :ok }
    end
  end

  def get_autocomplete_items(parameters)
    super(parameters).where("account_id = ?", current_user.account_id)
  end
end

class GuestsController < ApplicationController
	load_and_authorize_resource
  # GET /guests
  # GET /guests.json
  def index
		if params[:clear]
			session[:trip_id] = nil
			session[:guest_id] = nil
		end

		if (params[:name] or params[:phone_number] or params[:email_id])
			if params[:agency_id].to_i > 0
				@guests = @guests.paginate(page: params[:page], per_page: 20).
										order('name, resident_of').
										find(:all, :conditions => [ 
										'lower(name) like ? and
										(phone_number like ? or phone_number_2 like ?) and
										(email_id like ? or email_id_2 like ?) and agency_id = ?',
										"%" + params[:name] + "%",
										"%" + params[:phone_number] + "%",
										"%" + params[:phone_number] + "%",
										"%" + params[:email_id] + "%",
										"%" + params[:email_id] + "%", params[:agency_id] ])
			else
				@guests = @guests.paginate(page: params[:page], per_page: 20).
										order('name, resident_of').
										find(:all, :conditions => [ 
										'lower(name) like ? and
										(phone_number like ? or phone_number_2 like ?) and
										(email_id like ? or email_id_2 like ?)',
										"%" + params[:name] + "%",
										"%" + params[:phone_number] + "%",
										"%" + params[:phone_number] + "%",
										"%" + params[:email_id] + "%",
										"%" + params[:email_id] + "%" ])
			end
		else
			@guests = @guests.paginate(page: params[:page], per_page: 20).
									order('name, resident_of')
		end

		@records_returned = @guests.count

   	respond_to do |format|
     	format.html # index.html.erb
     	format.json { render json: @guests }
		end
  end

  # GET /guests/1
  # GET /guests/1.json
  def show
    respond_to do |format|
     	format.html # show.html.erb
     	format.json { render json: @guest }
    end
  end

  # GET /guests/new
  # GET /guests/new.json
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @guest }
    end
  end

  # GET /guests/1/edit
  def edit
  end

  # POST /guests
  # POST /guests.json
  def create
    respond_to do |format|
      if @guest.save
        format.html { redirect_to @guest, notice: 'Guest was successfully created.' }
        format.json { render json: @guest, status: :created, location: @guest }
      else
        format.html { render action: "new" }
        format.json { render json: @guest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /guests/1
  # PUT /guests/1.json
  def update
    respond_to do |format|
      if @guest.update_attributes(params[:guest])
        format.html { redirect_to @guest, notice: 'Guest was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @guest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /guests/1
  # DELETE /guests/1.json
  def destroy
    @guest.destroy

		if session[:guest_id] == params[:id].to_i
			session[:guest_id] = nil
		end

    respond_to do |format|
      format.html { redirect_to guests_url, alert: @guest.errors[:base][0] }
      format.json { head :ok }
    end
  end
end

class GuestsController < ApplicationController
  # GET /guests
  # GET /guests.json
  def index
		if params[:clear]
			session[:trip_id] = nil
			session[:guest_id] = nil
		end

		if (params[:name] or params[:phone_number] or params[:email_id])
			@guests = Guest.paginate(page: params[:page], per_page: 5).
									order('name, resident_of').
									find(:all, :conditions => [ 
									'lower(name) like ? and
									(phone_number like ? or phone_number_2 like ?) and
									(email_id like ? or email_id_2 like ?)',
									"%#{params[:name]}%",
									"%#{params[:phone_number]}%", "%#{params[:phone_number]}%",
									"%#{params[:email_id]}%", "%#{params[:email_id]}%" ])
		else
			@guests = Guest.paginate(page: params[:page], per_page: 5).
									order('name, resident_of').find(:all)
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
    @guest = Guest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @guest }
    end
  end

  # GET /guests/new
  # GET /guests/new.json
  def new
    @guest = Guest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @guest }
    end
  end

  # GET /guests/1/edit
  def edit
    @guest = Guest.find(params[:id])
  end

  # POST /guests
  # POST /guests.json
  def create
    @guest = Guest.new(params[:guest])

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
    @guest = Guest.find(params[:id])

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
    @guest = Guest.find(params[:id])
    @guest.destroy

		if session[:guest_id] == params[:id].to_i
			session[:guest_id] = nil
		end

    respond_to do |format|
      format.html { redirect_to guests_url, notice: @guest.errors[:base][0] }
      format.json { head :ok }
    end
  end
end

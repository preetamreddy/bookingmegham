class TripsController < ApplicationController
	load_and_authorize_resource

  # GET /trips
  # GET /trips.json
  def index
    customer = find_customer
    if customer
			store_customer_in_session(customer.class.name, customer.id)
    end

		if session[:customer_id]
			@trips = @trips.paginate(page: params[:page], per_page: 10).
								order("start_date DESC, end_date DESC").
								find(:all, :conditions => [
                     'customer_type = ? and customer_id = ?',
                     session[:customer_type], session[:customer_id] ])
		else
			if params[:status] == Trip::PARTIALLY_PAID
    				@trips = @trips.paginate(page: params[:page], per_page: 10).
					order("start_date DESC, end_date DESC").
					find_all_by_payment_status(params[:status])
			elsif params[:status] == Trip::NOT_PAID
    				@trips = @trips.paginate(page: params[:page], per_page: 10).
					order("start_date DESC, end_date DESC").
					find(:all, :conditions => [
       					'payment_status = ? and (price_for_rooms > 0 or price_for_transport > 0 or price_for_vas > 0)',
       					params[:status] ])
			elsif params[:status] == Trip::PAYMENT_OVERDUE
    				@trips = @trips.paginate(page: params[:page], per_page: 10).
					order('start_date DESC, end_date DESC').
					find(:all, :conditions => [
					'payment_status != ? and pay_by_date < ?',
					Trip::FULLY_PAID, Date.today ])
			elsif params[:status] == Trip::CHECKED_OUT
    				@trips = @trips.paginate(page: params[:page], per_page: 10).
					order('end_date, start_date').
					find(:all, :conditions => [
					'end_date >= ? and end_date <= ? and checked_out = ? and total_price > 0',
					Date.strptime('2017-07-01', '%Y-%m-%d'), Date.today, 0 ])
			else
    				@trips = @trips.paginate(page: params[:page], per_page: 10).
					order("start_date DESC, end_date DESC").all
			end
		end

    if session[:customer_id]
      customer = session[:customer_type].classify.constantize.
        scoped_by_account_id(current_user.account_id).find(session[:customer_id])
      @customer_name = customer.name
    end

    if params[:status]
      @status = params[:status]
    end

		@records_returned = @trips.count

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @trips }
    end
  end

  # GET /trips/1
  # GET /trips/1.json
  def show
   	respond_to do |format|
     	format.html # show.html.erb
     	format.json { render json: @trip }
    end
  end

  # GET /trips/new
  # GET /trips/new.json
  def new
    customer = find_customer
		if customer
			store_customer_in_session(customer.class.name, customer.id)
		end

    if session[:customer_id]
		  @trip.customer_type = session[:customer_type]
		  @trip.customer_id = session[:customer_id]
		  @trip.advisor_id = current_user.advisor_id
		  @trip.trip_rooms.build

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @trip }
      end
    else
      redirect_to guests_url, 
        alert: 'New trips can only be created after selecting a guest / agency.'
    end
  end

  # GET /trips/1/edit
  def edit
  end

  # POST /trips
  # POST /trips.json
  def create
    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip, notice: 'Trip was successfully created.' }
        format.json { render json: @trip, status: :created, location: @trip }
      else
        format.html { render action: "new" }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /trips/1
  # PUT /trips/1.json
  def update
    respond_to do |format|
      if @trip.update_attributes(params[:trip])
        format.html { redirect_to @trip, notice: 'Trip was successfully updated.' }
        format.json { head :ok }
			else
       	format.html { render action: "edit" }
       	format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trips/1
  # DELETE /trips/1.json
  def destroy
    if @trip.destroy
		  if session[:trip_id] == params[:id].to_i
			  session[:trip_id] = nil
		  end
    end

    respond_to do |format|
      format.html { redirect_to :back, alert: @trip.errors[:base][0] }
      format.json { head :ok }
    end
  end

	def email
		trip = Trip.scoped_by_account_id(current_user.account_id).find(params[:trip_id])
		if params[:type] == 'itinerary'
			TripNotifier.itinerary(trip, current_user.id).deliver
		elsif params[:type] == 'pro_forma_invoice'
			TripNotifier.pro_forma_invoice(trip, current_user.id).deliver
		elsif params[:type] == 'invoice'
			TripNotifier.invoice(trip, current_user.id).deliver
		elsif params[:type] == 'vouchers'
			TripNotifier.vouchers(trip, current_user.id).deliver
		elsif params[:type] == 'pre_gst_invoice'
			TripNotifier.pre_gst_invoice(trip, current_user.id).deliver
		end

		respond_to do |format|
			format.html { redirect_to trip, notice: 'Email was successfully sent.' }
      format.json { render json: trip, status: :sent, location: trip }
		end
	end

  private
    def store_customer_in_session(customer_type, customer_id)
      begin
			  if customer_type.classify.constantize.scoped_by_account_id(current_user.account_id).
	          find_all_by_id(customer_id).any?
				  session[:customer_type] = customer_type
				  session[:customer_id] = customer_id
				  session[:trip_id] = nil
			  end
      rescue NameError
        return true
      end
    end

    def find_customer
      params.each do |name, value|
        if name =~ /(.+)_id$/
          return $1.classify.constantize.scoped_by_account_id(current_user.account_id).find(value)
        end
      end
      nil
    end
end

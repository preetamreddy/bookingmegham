class PaymentsController < ApplicationController
	load_and_authorize_resource

  # GET /payments
  # GET /payments.json
  def index
		if params[:trip_id]
      store_trip_in_session(params[:trip_id].to_i)
		end

		if params[:from_date]
			@from_date = params[:from_date].to_date
		else
			@from_date = Date.today - 30
		end

		if params[:to_date]
			@to_date = params[:to_date].to_date
		else
			@to_date = Date.today
		end

		if session[:trip_id]
			@payments = @payments.paginate(page: params[:page], per_page: 20).
        order("date_received desc, trip_id desc, counter asc").
        find(:all, :conditions => ['trip_id = ?', session[:trip_id]])
		elsif session[:customer_id]
			trips = Trip.scoped_by_account_id(current_user.account_id).
        find(:all, :conditions => [
             'customer_type = ? and customer_id = ?',
             session[:customer_type], session[:customer_id] ])
			@payments = @payments.paginate(page: params[:page], per_page: 20).
        order("date_received desc, trip_id desc, counter asc").
				find_all_by_trip_id(trips)
		else
			@payments = @payments.paginate(page: params[:page], per_page: 20).
        order("date_received asc, trip_id asc, counter asc").find(:all, :conditions => [
					'date_received >= ? and date_received <= ?', @from_date, @to_date ])
		end

    if session[:trip_id]
      trip = Trip.scoped_by_account_id(current_user.account_id).find(session[:trip_id])
      @trip_name = trip.name
      @customer_name = trip.customer.name
    elsif session[:customer_id]
      customer = session[:customer_type].classify.constantize.
        scoped_by_account_id(current_user.account_id).find(session[:customer_id])
      @customer_name = customer.name
    end

		@records_returned = @payments.count

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @payments }
			format.csv { render :csv => @payments, :filename => "payments" }
    end
  end

  # GET /payments/1
  # GET /payments/1.json
  def show
   	respond_to do |format|
     	format.html # show.html.erb
     	format.json { render json: @payment }
		end
  end

  # GET /payments/new
  # GET /payments/new.json
  def new
		if session[:trip_id]
      trip = Trip.scoped_by_account_id(current_user.account_id).find(session[:trip_id])
			@payment.trip_id = trip.id
      @payment.payee_name = trip.customer.name_with_title
    end

    if session[:customer_id]
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @payment }
      end
    else
      redirect_to guests_url,
        alert: 'New payments can only be created after selecting a guest / agency.'
    end
  end

  # GET /payments/1/edit
  def edit
  end

  # POST /payments
  # POST /payments.json
  def create
    respond_to do |format|
      if @payment.save
        store_trip_in_session(@payment.trip_id)

        format.html { redirect_to @payment, notice: 'Payment was successfully created.' }
        format.json { render json: @payment, status: :created, location: @payment }
      else
        format.html { render action: "new" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /payments/1
  # PUT /payments/1.json
  def update
    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        format.html { redirect_to @payment, notice: 'Payment was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /payments/1
  # DELETE /payments/1.json
  def destroy
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :ok }
    end
  end

	def email
		payment = Payment.scoped_by_account_id(current_user.account_id).find(params[:payment_id])
		PaymentNotifier.receipt(payment, current_user.id).deliver

		respond_to do |format|
			format.html { redirect_to payment, notice: 'Email was successfully sent.' }
			format.json { render json: payment, status: :sent, location: payment }
		end
	end

  private
    def store_trip_in_session(trip_id)
			if Trip.scoped_by_account_id(current_user.account_id).find_all_by_id(trip_id).any?
			  trip = Trip.scoped_by_account_id(current_user.account_id).find(trip_id)
			  session[:trip_id] = trip.id
			  session[:customer_type] = trip.customer_type
			  session[:customer_id] = trip.customer_id
      end
    end
end

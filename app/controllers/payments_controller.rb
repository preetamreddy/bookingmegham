class PaymentsController < ApplicationController
	load_and_authorize_resource

  # GET /payments
  # GET /payments.json
  def index
		if params[:trip_id]
			trip_id = params[:trip_id].to_i
			if Trip.scoped_by_account_id(current_user.account_id).find_all_by_id(trip_id).any?
				session[:trip_id] = trip_id
				session[:guest_id] = Trip.scoped_by_account_id(current_user.account_id).find(trip_id).guest_id
			end
		end

		if params[:from_date]
			@from_date = Date.civil(
										params[:from_date][:year].to_i,
										params[:from_date][:month].to_i,
										params[:from_date][:day].to_i)
		else
			@from_date = Date.today - 30
		end

		if params[:number_of_days]
			@number_of_days = params[:number_of_days].to_i
		else
			@number_of_days = 30 
		end

		@to_date = @from_date + @number_of_days

		if session[:trip_id]
			@payments = @payments.order("trip_id, date_received, id").find(:all, :conditions => [
											'trip_id = ?', session[:trip_id] ])
		else
			@payments = @payments.order("trip_id, date_received, id").find(:all, :conditions => [
											'date_received >= ? and date_received <= ?',
											@from_date, @to_date ])
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
			@payment.trip_id = session[:trip_id]
			@payment.payee_name = Trip.find(session[:trip_id]).guest.name_with_title
		end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @payment }
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
      format.html { redirect_to payments_url }
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
end

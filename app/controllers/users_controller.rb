class UsersController < ApplicationController
  # GET /users
  # GET /users.json
  def index
		if params[:agency_id] == 'All'
			session[:agency_id] = nil
		elsif params[:agency_id]
			agency_id = params[:agency_id].to_i
			if Agency.find_all_by_id(agency_id).any?
				session[:agency_id] = params[:agency_id].to_i
			end
		end

		if session[:agency_id]
			@users = User.order(:email).
								find_all_by_agency_id(session[:agency_id])
		else
    	@users = User.order('agency_id, email').all
		end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @user = User.new

		advisor_id = params[:advisor_id].to_i
		advisor = Advisor.find(advisor_id)

		@user.advisor_id = params[:advisor_id]
		@user.agency_id = advisor.agency.id
		@user.email = advisor.email

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
		begin
    	@user = User.find(params[:id])
		rescue ActiveRecord::RecordNotFound
			logger.error "Attempt to access invalid user #{params[:id]}"
			redirect_to users_url, notice: 'Invalid User'
		end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
		generated_password = Devise.friendly_token.first(8)
		@user.password = generated_password
		@user.password_confirmation = generated_password

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: 'User was successfully activated.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to users_url, notice: 'User was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])

		begin
    	@user.destroy
			flash[:notice] = "User #{@user.email} deactivated"
		rescue Exception => e
			flash[:notice] = e.message
		end

    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :ok }
    end
  end

  # GET /users/1/change_password
  def change_password
   	@user = current_user
  end

  def update_password
    @user = current_user
    if @user.update_with_password(params[:user])
			sign_in @user, :bypass => true
      redirect_to root_path, notice: 'Password was successfully changed.'
    else
      render "change_password"
    end
  end

end

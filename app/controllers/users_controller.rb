class UsersController < ApplicationController
	before_filter :find_current_user, :only => [:change_password, :update_password]
	load_and_authorize_resource
  # GET /users
  # GET /users.json
  def index
    @users = @users.order('email')

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
		advisor_id = params[:advisor_id].to_i
		advisor = Advisor.find(advisor_id)

		@user.account_id = advisor.account_id
		@user.advisor_id = advisor.id
		@user.email = advisor.email_id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # POST /users
  # POST /users.json
  def create
		generated_password = Devise.friendly_token.first(8)
		@user.password = generated_password
		@user.password_confirmation = generated_password
		@user.reset_password_token = User.reset_password_token
		@user.reset_password_sent_at = Time.now

    respond_to do |format|
      if @user.save
				UserNotifier.welcome(@user, current_user).deliver
        format.html { redirect_to users_url, notice: 'User was successfully activated.' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, alert: @user.errors[:base][0] }
      format.json { head :ok }
    end
  end

	# Load current_user into the instance variable
	def find_current_user
		@user = current_user
	end

  # GET /users/1/change_password
  def change_password
  end

  def update_password
    if @user.update_with_password(params[:user])
			sign_in @user, :bypass => true
      redirect_to root_path, notice: 'Password was successfully changed.'
    else
      render "change_password"
    end
  end

	def become
		sign_in User.find(params[:id]), :bypass => true
		redirect_to root_url
	end

end

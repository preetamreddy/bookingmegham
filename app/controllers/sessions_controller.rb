class SessionsController < ApplicationController
	skip_before_filter :authorize

  def new
		if User.find_by_id(session[:user_id])
			redirect_to availability_chart_url
		end
  end

  def create
		user = User.find_by_name(params[:name])
		if user and user.authenticate(params[:password])
			session[:user_id] = user.id
			session[:agency] = user.agency.name
			session[:guest_id] = nil
			session[:trip_id] = nil
			session[:last_request] = Time.now
			redirect_to availability_chart_url
		else
			redirect_to login_url, alert: "Invalid user / password combination"
		end
  end

  def destroy
		session[:user_id] = nil
		session[:property_id] = nil
		session[:agency_id] = nil
		session[:guest_id] = nil
		session[:trip_id] = nil
		redirect_to login_url, alert: "Logged out"
  end

end

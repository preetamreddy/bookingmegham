class ApplicationController < ActionController::Base
  protect_from_forgery

	before_filter :authorize

	protected
		
		def authorize
			if User.find_by_id(session[:user_id])
				if session[:last_request] < 10.minute.ago
					session[:user_id] = nil
					session[:last_request] = nil
					redirect_to login_url, alert: "Timed out. Please log in again"
				else
					session[:last_request] = Time.now
				end
			else
				redirect_to login_url, alert: "Please log in"
			end
		end
end

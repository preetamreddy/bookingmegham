class ApplicationController < ActionController::Base
  protect_from_forgery

	before_filter :authorize, :ensure_domain

	APP_DOMAIN = 'www.ezbook.in'
	APP_DOMAIN_SANS_WWW = 'ezbook.in'
	APP_DOMAIN_HEROKUAPP = 'bookingmegham.herokuapp.com'

	protected
		
		def authorize
			if User.find_by_id(session[:user_id])
				if session[:last_request] < 60.minutes.ago
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

		def ensure_domain
			if [APP_DOMAIN_SANS_WWW, APP_DOMAIN_HEROKUAPP].include? request.env['HTTP_HOST']
				# HTTP 301 is a permanent redirect
				redirect_to "http://#{APP_DOMAIN}", :status => 301
			end
		end
end

class ApplicationController < ActionController::Base
  protect_from_forgery

	before_filter :authorize, :ensure_domain

	APP_DOMAIN = 'www.ezbook.in'
	APP_DOMAIN_SANS_WWW = 'ezbook.in'

	protected
		
		def authorize
			if User.find_by_id(session[:user_id])
				if session[:last_request] < 10.minutes.ago
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
			if request.env['HTTP_HOST'] == APP_DOMAIN_SANS_WWW
				# HTTP 301 is a permanent redirect
				redirect_to "http://#{APP_DOMAIN}", :status => 301
			end
		end
end

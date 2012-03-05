class ApplicationController < ActionController::Base
  protect_from_forgery

	before_filter :authorize, :ensure_domain

	APP_DOMAIN = 'www.ezbook.in'
	APP_DOMAIN_SANS_WWW = 'ezbook.in'
	APP_DOMAIN_HEROKUAPP = 'bookingmegham.herokuapp.com'

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
			if [APP_DOMAIN_SANS_WWW, APP_DOMAIN_HEROKUAPP].include? request.env['HTTP_HOST']
				# HTTP 301 is a permanent redirect
				redirect_to "http://#{APP_DOMAIN}", :status => 301
			end
		end

  def sort_for_contiguous_rooms(available_rooms, rooms_required)
    available_rooms = available_rooms.sort
    first_room_number = 0
    i = 0
    while (available_rooms.length - rooms_required + 1 - i) > 0
      (0..(rooms_required - 1)).each do |r|
        n = available_rooms.first
        if available_rooms.index(n + r)
          first_room_number = n
        else
          first_room_number = 0
          break
        end
      end
      if first_room_number > 0
        break
      else
        i += 1
        available_rooms = available_rooms.rotate
      end
    end
    return available_rooms
  end

end

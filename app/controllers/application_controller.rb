class ApplicationController < ActionController::Base
  protect_from_forgery
	layout :layout_by_resource

	before_filter :authenticate_user!, :ensure_domain

  rescue_from CanCan::AccessDenied do |exception|
		render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
	end

  rescue_from ActiveRecord::RecordNotFound do |exception|
		render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
	end

	APP_DOMAIN = 'www.ezbook.in'
	APP_DOMAIN_SANS_WWW = 'ezbook.in'
	APP_DOMAIN_HEROKUAPP = 'bookingmegham.herokuapp.com'

	protected
		def ensure_domain
			if [APP_DOMAIN_SANS_WWW, APP_DOMAIN_HEROKUAPP].include? request.env['HTTP_HOST']
				# HTTP 301 is a permanent redirect
				redirect_to "http://#{APP_DOMAIN}", :status => 301
			end
		end

		def layout_by_resource
			if devise_controller?
				"public"
			else
				"application"
			end
		end

	private
		def after_sign_in_path_for(resource)
			stored_location_for(resource) || root_path
		end
end

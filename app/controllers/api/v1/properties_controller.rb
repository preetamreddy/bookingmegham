module Api
  module V1
    class PropertiesController < ApplicationController
	    skip_before_filter :authenticate_user!

		  def check_availability
		    @response = ''
		
		    id = params[:id].to_i
		
		    nights = params[:nights].to_i
		    @nights = nights == 0 ? '' : nights
		    if nights > 9
		      @response = 'Availability check cannot be performed for more than 9 nights'
		    end
		
		    rooms = params[:rooms].to_i
		    @rooms = rooms == 0 ? '' : rooms
		    if rooms > 3
		      @response = 'Availability check cannot be performed for more than 3 rooms'
		    end
		
		    if params[:check_in] 
		      begin
		        check_in = params[:check_in].to_date
		        check_out = check_in + nights
		        @check_in = check_in
		      rescue
		        @response = 'Please enter date as DD-MON-YYYY'
		      end
		    end
		
		    @properties = Property.find_all_by_id(id)
		    if @properties.any? and check_in and check_out and @response == ''
		      property = Property.find(id)
		      if property.allow_online_availability_check == 1
		        response = property.availability(check_in, check_out, rooms)
		        @response = (response ? 'Available' : 'Sold out') + " as of " + DateTime.current.to_s(:short)
		      end
		    end
		
		    response_json = {"response" => @response}
		
		    respond_to do |format|
		      format.json { render :json => response_json }
		      format.js { render :json => response_json, :callback => params[:callback] }
		    end
		  end
    end
  end
end

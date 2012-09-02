class TaxiBookingNotifier < ActionMailer::Base
  default from: "EZBook <info@ezbook.in>"

  def details(taxi_booking)
		@taxi_booking = taxi_booking
		@trip = taxi_booking.trip

   	mail(to: "#{@trip.advisor.name} <#{@trip.advisor.email_id}>",
				subject: 'New Taxi Booking from Banjara Camps') do |format|
			format.text
		end
  end

end

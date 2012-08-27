class TaxiBookingNotifier < ActionMailer::Base
	ACCOUNTS_EMAIL_ID = "accounts@banjaracamps.com"

	default from: "Banjara Camps <banjaracamps@ezbook.in>"

  def details(taxi_booking)
		@taxi_booking = taxi_booking
		@trip = taxi_booking.trip

   	mail(to: "#{@trip.advisor.name} <#{@trip.advisor.email_id}>",
				subject: 'New Taxi Booking from Banjara Camps') do |format|
			format.text
		end
  end

end

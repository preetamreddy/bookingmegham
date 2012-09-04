class TaxiBookingNotifier < ActionMailer::Base
  default from: "EZBook <info@ezbook.in>"

  def details(taxi_booking)
		@taxi_booking = taxi_booking
		@trip = taxi_booking.trip
    @account_setting = AccountSetting.find_by_account_id(@trip.account_id)

   	mail(to: "#{@trip.advisor.name} <#{@trip.advisor.email_id}>",
				subject: "Taxi booking request from #{@account_setting.name}") do |format|
			format.text
		end
  end

end

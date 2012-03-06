class TripNotifier < ActionMailer::Base
	ACCOUNTS_EMAIL_ID = "accounts@banjaracamps.com"

	default from: "Banjara Camps <banjaracamps@ezbook.in>"

  def details(trip)
		@trip = trip

#		mail to: "#{@trip.guest.name} <#{@trip.guest.email_id}>", 
#    	cc: "#{@trip.email_ids}, #{@trip.advisor.name} <#{@trip.advisor.email_id}>",
   	mail(to: "#{@trip.advisor.name} <#{@trip.advisor.email_id}>",
				subject: 'Your holiday with Banjara Camps - Trip details') do |format|
			format.text
			format.pdf do
				attachments["trip_details.pdf"] = WickedPdf.new.pdf_from_string(
					render_to_string(:pdf => "trip_details", 
					:template 						=> 'trip_notifier/details.pdf.erb'))
			end
		end
  end

  def invoice(trip)
		@trip = trip

		mail to: "#{@trip.guest.name} <#{@trip.guest.email_id}>", 
			cc: "#{@trip.email_ids}, #{@trip.advisor.name} <#{@trip.advisor.email_id}>, #{ACCOUNTS_EMAIL_ID}",
			subject: 'Your holiday with Banjara Camps - Invoice'
  end

  def receipt(trip)
		@trip = trip

		mail to: "#{@trip.guest.name} <#{@trip.guest.email_id}>", 
			cc: "#{@trip.email_ids}, #{@trip.advisor.name} <#{@trip.advisor.email_id}>, #{ACCOUNTS_EMAIL_ID}",
			subject: 'Your holiday with Banjara Camps - Receipt'
  end

  def voucher(trip)
		@trip = trip

		mail to: "#{@trip.guest.name} <#{@trip.guest.email_id}>", 
			cc: "#{@trip.email_ids}, #{@trip.advisor.name} <#{@trip.advisor.email_id}>",
			subject: 'Your holiday with Banjara Camps - Voucher'
  end
end

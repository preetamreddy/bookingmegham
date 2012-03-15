class TripNotifier < ActionMailer::Base
	Linguistics::use( :en )
	add_template_helper(ApplicationHelper)

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
					:template 						=> 'trip_notifier/details.pdf.erb',
					:layout								=> 'layouts/default.html.erb',
					:header => {:html => {:template => 'layouts/header.pdf.erb'}},
					:footer => {:html => {:template => 'layouts/footer.pdf.erb'}},
					:margin => {:top 		=> 25,
											:bottom	=> 30,
											:left		=> 20,
											:right	=> 20}))
			end
		end
  end

  def invoice(trip)
		@trip = trip

#		mail(to: "#{@trip.guest.name} <#{@trip.guest.email_id}>", 
#			cc: "#{@trip.email_ids}, #{@trip.advisor.name} <#{@trip.advisor.email_id}>, #{ACCOUNTS_EMAIL_ID}",
#		mail(to: "#{@trip.advisor.name} <#{@trip.advisor.email_id}>",
		mail(to: "preetam@ezbook.in",
				subject: 'Your holiday with Banjara Camps - Invoice') do |format|
			format.text
			format.pdf do
				attachments["trip_invoice.pdf"] = WickedPdf.new.pdf_from_string(
					render_to_string(:pdf => "trip_invoice", 
					:template 						=> 'trip_notifier/invoice.pdf.erb',
					:layout								=> 'layouts/default.html.erb'))
			end
		end
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

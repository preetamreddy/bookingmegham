class TripNotifier < ActionMailer::Base
	add_template_helper(ApplicationHelper)

	ACCOUNTS_EMAIL_ID = "accounts@banjaracamps.com"

	default from: "Banjara Camps <banjaracamps@ezbook.in>"

  def itinerary(trip, user_id)
		@trip = trip
		@user = User.find(user_id)

		mail(to: "#{@user.advisor.name} <#{@user.advisor.email_id}>",
				subject: 'Banjara Camps - Itinerary for your holiday with us') do |format|
			format.text
			format.pdf do
				attachments["Itinerary #{@trip.guest.name}.pdf"] = WickedPdf.new.pdf_from_string(
					render_to_string(:pdf => "itinerary", 
					:template 						=> 'trip_notifier/itinerary.pdf.erb',
					:layout								=> 'layouts/default.html.erb'))
			end
		end
  end

  def invoice(trip, user_id)
		@trip = trip
		@user = User.find(user_id)

		mail(to: "#{@user.advisor.name} <#{@user.advisor.email_id}>",
				subject: "Banjara Camps - Invoice for trip #{@trip.id}/#{@trip.guest.name}") do |format|
			format.text
			format.pdf do
				attachments["Invoice #{@trip.agency.name} (ref: #{@trip.id}/#{@trip.guest.name}).pdf"] = 
					WickedPdf.new.pdf_from_string(
					render_to_string(:pdf => "invoice", 
					:template 						=> 'trip_notifier/invoice.pdf.erb',
					:layout								=> 'layouts/default.html.erb'))
			end
		end
  end

  def vouchers(trip, user_id)
		@trip = trip
		@user = User.find(user_id)

		mail(to: "#{@user.advisor.name} <#{@user.advisor.email_id}>",
				subject: "Banjara Camps - Vouchers for trip #{@trip.id}/#{@trip.guest.name}") do |format|
			format.text
			format.pdf do
				attachments["Vouchers for Trip #{@trip.id}/#{@trip.guest.name}.pdf"] = 
					WickedPdf.new.pdf_from_string(
					render_to_string(:pdf => "vouchers", 
					:template 						=> 'trip_notifier/vouchers.pdf.erb',
					:layout								=> 'layouts/default.html.erb'))
			end
		end
  end
end

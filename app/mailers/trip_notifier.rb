class TripNotifier < ActionMailer::Base
	add_template_helper(ApplicationHelper)

  default from: "EZBook <info@ezbook.in>"

  def itinerary(trip, user_id)
		@trip = trip
		@user = User.find(user_id)
    @account_setting = AccountSetting.find_by_account_id(@user.account_id)

		mail(to: "#{@user.advisor.name} <#{@user.advisor.email_id}>",
				subject: "Itinerary for your trip, ##{@trip.id} (ref: #{@trip.name})") do |format|
			format.text
			format.pdf do
				attachments["Itinerary #{@trip.itinerary_number} (ref: #{@trip.name}).pdf"] = WickedPdf.new.pdf_from_string(
					render_to_string(:pdf => "itinerary", 
					:template 						=> 'trip_notifier/itinerary.pdf.erb',
					:layout								=> 'layouts/default.html.erb'))
			end
		end
  end

  def invoice(trip, user_id)
		@trip = trip
		@user = User.find(user_id)
    @account_setting = AccountSetting.find_by_account_id(@user.account_id)

		mail(to: "#{@user.advisor.name} <#{@user.advisor.email_id}>",
				subject: "Invoice for your trip, ##{@trip.id} (ref: #{@trip.name})") do |format|
			format.text
			format.pdf do
				attachments["Invoice #{@trip.invoice_number} (ref: #{@trip.name}).pdf"] = 
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
    @account_setting = AccountSetting.find_by_account_id(@user.account_id)

		mail(to: "#{@user.advisor.name} <#{@user.advisor.email_id}>",
				subject: "Vouchers for your trip, ##{@trip.id} (ref: #{@trip.name})") do |format|
			format.text
			format.pdf do
				attachments["Vouchers #{@trip.voucher_number} (ref: #{@trip.name}).pdf"] = 
					WickedPdf.new.pdf_from_string(
					render_to_string(:pdf => "vouchers", 
					:template 						=> 'trip_notifier/vouchers.pdf.erb',
					:layout								=> 'layouts/default.html.erb'))
			end
		end
  end
end

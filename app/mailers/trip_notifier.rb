class TripNotifier < ActionMailer::Base
	add_template_helper(ApplicationHelper)

  default from: "EZBook <info@ezbook.in>"

  def itinerary(trip, user_id)
		@trip = trip
		@user = User.find(user_id)
    @account_setting = AccountSetting.find_by_account_id(@user.account_id)

		mail(to: "#{@user.advisor.name} <#{@user.advisor.email_id}>",
				subject: "Itinerary for trip, #{@trip.customer.name} ##{@trip.id} (ref: #{@trip.name})") do |format|
			format.text
			format.pdf do
				attachments["Itinerary #{@trip.itinerary_number} (ref: #{@trip.name}).pdf"] = WickedPdf.new.pdf_from_string(
					render_to_string(:pdf => "itinerary", 
					:template 						=> 'trip_notifier/itinerary.pdf.erb',
					:layout								=> 'layouts/default.html.erb'))
			end
		end
  end

  def pro_forma_invoice(trip, user_id)
		@trip = trip
		@user = User.find(user_id)
    @account_setting = AccountSetting.find_by_account_id(@user.account_id)

		mail(to: "#{@user.advisor.name} <#{@user.advisor.email_id}>",
				subject: "Pro forma Invoice for trip, #{@trip.customer.name} ##{@trip.id} (ref: #{@trip.name})") do |format|
			format.text
			format.pdf do
				attachments["ProFormaInvoice #{@trip.invoice_number} (ref: #{@trip.name}).pdf"] = 
					WickedPdf.new.pdf_from_string(
					render_to_string(:pdf => "pro_forma_invoice", 
					:template 						=> 'trip_notifier/pro_forma_invoice.pdf.erb',
					:layout								=> 'layouts/default.html.erb'))
			end
		end
  end

  def invoice(trip, user_id)
		@trip = trip
		@user = User.find(user_id)
    @account_setting = AccountSetting.find_by_account_id(@user.account_id)

		mail(to: "#{@user.advisor.name} <#{@user.advisor.email_id}>",
				subject: "Invoice for trip, #{@trip.customer.name} ##{@trip.id} (ref: #{@trip.name})") do |format|
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
				subject: "Vouchers for trip, #{@trip.customer.name} ##{@trip.id} (ref: #{@trip.name})") do |format|
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

  def pre_gst_invoice(trip, user_id)
		@trip = trip
		@user = User.find(user_id)
    @account_setting = AccountSetting.find_by_account_id(@user.account_id)

		mail(to: "#{@user.advisor.name} <#{@user.advisor.email_id}>",
				subject: "Invoice for trip, #{@trip.customer.name} ##{@trip.id} (ref: #{@trip.name})") do |format|
			format.text
			format.pdf do
				attachments["Invoice #{@trip.invoice_number} (ref: #{@trip.name}).pdf"] = 
					WickedPdf.new.pdf_from_string(
					render_to_string(:pdf => "pre_gst_invoice", 
					:template 						=> 'trip_notifier/pre_gst_invoice.pdf.erb',
					:layout								=> 'layouts/default.html.erb'))
			end
		end
  end
end

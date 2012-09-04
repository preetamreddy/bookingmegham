class PaymentNotifier < ActionMailer::Base
	add_template_helper(ApplicationHelper)

  default from: "EZBook <info@ezbook.in>"

  def receipt(payment, user_id)
		@payment = payment
		@trip = @payment.trip
		@user = User.find(user_id)
    @account_setting = AccountSetting.find_by_account_id(@user.account_id)

		mail(to: "#{@user.advisor.name} <#{@user.advisor.email_id}>",
				subject: "Receipt for your payment towards the trip, ##{@payment.trip_id} (ref: #{@payment.trip.name})") do |format|
			format.text
			format.pdf do
				attachments["Receipt #{@payment.receipt_number} (ref: #{@trip.name}).pdf"] = 
					WickedPdf.new.pdf_from_string(
					render_to_string(:pdf => "receipt", 
					:template 						=> 'payment_notifier/receipt.pdf.erb',
					:layout								=> 'layouts/default.html.erb'))
			end
		end
  end
end

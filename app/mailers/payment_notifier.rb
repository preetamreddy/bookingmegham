class PaymentNotifier < ActionMailer::Base
	add_template_helper(ApplicationHelper)

	ACCOUNTS_EMAIL_ID = "accounts@banjaracamps.com"

	default from: "Banjara Camps <banjaracamps@ezbook.in>"

  def receipt(payment, user_id)
		@payment = payment
		@trip = @payment.trip
		@user = User.find(user_id)

		mail(to: "#{@user.advisor.name} <#{@user.advisor.email_id}>",
				subject: "Payment Receipt for trip #{@payment.trip_id}-#{@payment.trip.name}") do |format|
			format.text
			format.pdf do
				attachments["Receipt #{@trip.id}/#{@payment.id}/#{@trip.name}.pdf"] = 
					WickedPdf.new.pdf_from_string(
					render_to_string(:pdf => "receipt", 
					:template 						=> 'payment_notifier/receipt.pdf.erb',
					:layout								=> 'layouts/default.html.erb'))
			end
		end
  end

end

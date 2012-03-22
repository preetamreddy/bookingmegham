class PaymentNotifier < ActionMailer::Base
	add_template_helper(ApplicationHelper)

	ACCOUNTS_EMAIL_ID = "accounts@banjaracamps.com"

	default from: "Banjara Camps <banjaracamps@ezbook.in>"

  def receipt(payment, user_id)
		@payment = payment
		@user = User.find(user_id)

		mail(to: "#{@user.advisor.name} <#{@user.advisor.email_id}>",
				subject: "Banjara Camps - Payment Receipt for trip #{@trip.id}/#{@trip.guest.name}") do |format|
			format.text
		end
  end

end

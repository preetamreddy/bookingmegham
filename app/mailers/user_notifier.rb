class UserNotifier < ActionMailer::Base
  default from: "EZBook <info@ezbook.in>"

	def welcome(invitee, inviter)
		@invitee = invitee
		@inviter = inviter

   	mail(to: "#{@invitee.advisor.name} <#{@invitee.email}>",
				 cc: "#{@inviter.advisor.name} <#{@inviter.email}>",
				subject: 'Welcome to EZBook') do |format|
			format.html
		end
	end
end

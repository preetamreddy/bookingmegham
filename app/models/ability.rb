class Ability
  include CanCan::Ability

  def initialize(user)
		if user.is? "Super admin"
			can :manage, :all
		else
			can :manage, :all, :account_id => user.account_id
		end

		if user.is? "Super admin"
			cannot :destroy, Advisor, :id => user.advisor_id
			cannot :destroy, User, :id => user.id
		end

		if user.is? "Account admin"
			cannot :manage, Account
			cannot [:update, :destroy], Feedback
			cannot :destroy, Advisor, :id => user.advisor_id
			cannot :become, User
			cannot :destroy, User, :id => user.id
		end

		if user.is? "Advisor"
			cannot :manage, [Account, Advisor, User]
			cannot [:update, :destroy], Feedback
		end
	end
end

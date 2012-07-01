class User < ActiveRecord::Base
	ROLES = %w[super_admin account_admin advisor]

	belongs_to :account
	belongs_to :advisor

	validates :email, :password, :password_confirmation, :presence => :true

  # Include default devise modules. Others available are:
  # :token_authenticatable, :rememberable, :confirmable,
  # :omniauthable, ;registerable
  devise 	:database_authenticatable,
         	:recoverable, :trackable, :validatable,
  				:lockable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :account_id, :advisor_id, :role

	def is?(user_role)
		role.humanize == user_role
	end

	def agency
		Agency.find_by_account_id_and_is_account(account_id, 1)
	end
end

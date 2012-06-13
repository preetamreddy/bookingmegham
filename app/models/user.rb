class User < ActiveRecord::Base
	belongs_to :advisor
	belongs_to :agency

	validates :email, :password, :password_confirmation, :presence => :true

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :rememberable
  # :omniauthable, ;registerable
  devise 	:database_authenticatable,
         	:recoverable, :trackable, :validatable,
  				:lockable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :agency_id, :advisor_id, :name
end

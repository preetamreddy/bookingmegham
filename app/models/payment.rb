class Payment < ActiveRecord::Base
	belongs_to :trip

	validate :date_recieved, :amount, presence: true

	validates_numericality_of :amount,
		only_integer: true, greater_than: 0, allow_nil: true,
		message: "should be a number greater than 0"

end

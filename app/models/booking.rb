class Booking < ActiveRecord::Base
	validates :guest_name, :guest_phone_number, :number_of_rooms, :from, :to,
						:number_of_adults, :number_of_children, :number_of_infants,
						:total_price, :paid, :balance_payment, :pay_by_date, presence: true
	validates_numericality_of :guest_phone_number, 
														:number_of_rooms, :number_of_adults, 
														:total_price, :paid, :balance_payment,
														only_integer: true, greater_than: 0, 
														allow_nil: true, 
														message: "should be a number greater than 0"
	validates_numericality_of :number_of_children, :number_of_infants,
														only_integer: true, greater_than_or_equal_to: 0,
														allow_nil: true, 
														message: "should be a positive number or zero"
end

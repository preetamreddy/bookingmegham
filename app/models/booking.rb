class Booking < ActiveRecord::Base
	versioned :dependent => :tracking

	belongs_to :room_type

	validates :guest_name, :guest_phone_number, :number_of_rooms, :from, :to,
						:number_of_adults, :number_of_children, :number_of_infants,
						:total_price, :paid, :balance_payment, :pay_by_date,
						:room_type_id, presence: true
	validates_numericality_of :guest_phone_number, :number_of_rooms, 
														:number_of_adults, :room_type_id,
														only_integer: true, greater_than: 0, 
														allow_nil: true, 
														message: "should be a number greater than 0"
	validates_numericality_of :number_of_children, :number_of_infants,
														:total_price, :paid, :balance_payment,
														only_integer: true, greater_than_or_equal_to: 0,
														allow_nil: true, 
														message: "should be a positive number or zero"
end

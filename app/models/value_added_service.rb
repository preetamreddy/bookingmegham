class ValueAddedService < ActiveRecord::Base
	belongs_to :property

	has_many :vas_bookings

	validates :name, :unit_price, presence: true

	validates_numericality_of :property_id, :unit_price, 
						only_integer: true, greater_than: 0, allow_nil: true,
						message: "should be a number greater than 0"

	def self.unit_price(id)
		value_added_service = ValueAddedService.find(id)
		
		return value_added_service.unit_price
	end

end

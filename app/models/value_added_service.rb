class ValueAddedService < ActiveRecord::Base
	belongs_to :property

	validates :name, :unit_price, presence: true

	validates_numericality_of :property_id, :unit_price, 
						only_integer: true, greater_than: 0, allow_nil: true,
						message: "should be a number greater than 0"

end

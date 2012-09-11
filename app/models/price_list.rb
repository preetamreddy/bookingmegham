class PriceList < ActiveRecord::Base
  belongs_to :room_type

  validates :room_type_id, :account_id, 
    :price_for_single_occupancy, :price_for_double_occupancy,
    :price_for_extra_adults, :price_for_children, :price_for_infants,
    :presence => true
  validates_numericality_of :room_type_id, :account_id, 
    :price_for_single_occupancy, :price_for_double_occupancy,
    :price_for_extra_adults, :price_for_children, :price_for_infants,
    :allow_nil => true, :only_integer => true, :greater_than => 0,
    message: "should be a number greater thab 0"
end

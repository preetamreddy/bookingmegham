class TaxiBooking < ActiveRecord::Base
	belongs_to :trip
	belongs_to :taxi

	has_many :taxi_details, dependent: :destroy
		accepts_nested_attributes_for :taxi_details, :reject_if => :all_blank,
		:allow_destroy => true

	validates :trip_id, :taxi_id, :number_of_vehicles, presence: true

	before_save :update_unit_price

	private
	
		def update_unit_price
			self.unit_price = taxi.unit_price
		end
end

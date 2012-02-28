class TrekPrice < ActiveRecord::Base
	belongs_to :trek

	validate :unit_price, :min_group_size, :max_group_size, presence: true

	validates_numericality_of :trek_id, :unit_price,
		only_integer: true, greater_than: 0, allow_nil: true,
		message: "should be a number greater than 0"

	validates_numericality_of :min_group_size, :max_group_size,
		only_integer: true, greater_than: 0, less_than: 100, allow_nil: true,
		message: "should be a number between 1 and 99"

	before_validation :set_defaults_if_nil

	private

		def set_defaults_if_nil
			self.min_group_size ||= 1
			self.max_group_size ||= 99
		end
end

class VasPrice < ActiveRecord::Base
	belongs_to :value_added_service

	validates :unit_price, :min_group_size, :max_group_size, presence: true

	validates_numericality_of :value_added_service_id,
						:unit_price, :min_group_size, :max_group_size,
						only_integer: true, greater_than: 0, allow_nil: true,
						message: "should be a number greater than 0"

	before_validation :set_defaults_if_nil

	private
		def set_defaults_if_nil
			self.min_group_size ||= 1
			self.max_group_size ||= 999
		end

end

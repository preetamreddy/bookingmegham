class ValueAddedService < ActiveRecord::Base
	belongs_to :property

	has_many :vas_bookings

	before_save :titleize, :strip_whitespaces

	before_destroy :ensure_not_referenced_by_vas_bookings

	validates :name, presence: true

	validates_numericality_of :property_id,
						only_integer: true, greater_than: 0, allow_nil: true,
						message: "should be a number greater than 0"

	private
		
		def ensure_not_referenced_by_vas_bookings
			if vas_bookings.empty?
				return true
			else
				errors.add(:base, "Destroy failed because #{name} has bookings")
				return false
			end
		end

		def titleize
			self.name = name.titleize
		end

		def strip_whitespaces
			self.description = description.strip
		end
end

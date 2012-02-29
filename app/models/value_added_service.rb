class ValueAddedService < ActiveRecord::Base
	belongs_to :property

	has_many :vas_bookings

	has_many :vas_prices, dependent: :destroy
		accepts_nested_attributes_for :vas_prices, :reject_if => :all_blank,
		:allow_destroy => true

	before_save :titleize

	before_destroy :ensure_not_referenced_by_vas_bookings

	validates :name, presence: true

	validates_numericality_of :property_id,
						only_integer: true, greater_than: 0, allow_nil: true,
						message: "should be a number greater than 0"

	def self.unit_price(id, number_of_people)
		vas = ValueAddedService.find(id)

		price = 0
		vas.vas_prices.each do |vas_price|
			if vas_price.min_group_size <= number_of_people and
					vas_price.max_group_size >= number_of_people
				price = vas_price.unit_price							
			end
		end

		return price
	end

	def is_trek?
		return is_trek
	end

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
end

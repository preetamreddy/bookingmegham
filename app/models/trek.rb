class Trek < ActiveRecord::Base
	DIFFICULTY = ["Easy", "Medium", "Difficult"]

	has_many :trek_bookings

	has_many :trek_prices, dependent: :destroy
	accepts_nested_attributes_for :trek_prices, :reject_if => :all_blank,
		:allow_destroy => true

	before_destroy :ensure_not_referenced_by_trek_bookings

	validates :name, :number_of_days, presence: true

	validates_numericality_of :number_of_days,
		only_integer: true, greater_than: 0, less_than: 100, allow_nil: true,
		message: "should be a number between 1 and 99"

	def self.unit_price(id, number_of_people)
		trek = Trek.find(id)

		price = 0
		trek.trek_prices.each do |trek_price|
			if trek_price.min_group_size <= number_of_people and
					trek_price.max_group_size >= number_of_people
				price = trek_price.unit_price
			end
		end

		return price
	end

	private

		def ensure_not_referenced_by_trek_bookings
			if trek_bookings.empty?
				return true
			else
				errors.add(:base, "Destroy failed because trek '#{name}' has bookings.")
				return false
			end
		end
end

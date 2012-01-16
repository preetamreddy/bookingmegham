class Trip < ActiveRecord::Base
	PAYMENT_STATUS = [ "Blocked", "Partially Paid", "Fully Paid" ]

	belongs_to :guest

	has_many :rooms, dependent: :destroy
	accepts_nested_attributes_for :rooms, :reject_if => :all_blank,
		:allow_destroy => true

	has_many :bookings

	has_many :payments, dependent: :destroy
	accepts_nested_attributes_for :payments, :reject_if => :all_blank,
		:allow_destroy => true

	before_save :set_defaults_if_nil

	before_destroy :ensure_not_referenced_by_booking

	validates :guest_id, :name, :start_date, :end_date, presence: true

	validates_numericality_of :guest_id,
						only_integer: true, greater_than: 0, allow_nil: true,
						message: "should be a number greater than 0"

	validates_numericality_of :number_of_children_below_5_years, 
						:number_of_drivers,
						only_integer: true, greater_than_or_equal_to: 0, allow_nil: true,
						message: "should be a number greater than or equal to 0"

	validates :payment_status, inclusion: PAYMENT_STATUS, allow_nil: true

	validate :ensure_guest_exists, :ensure_end_date_is_greater_than_start_date

	def number_of_adults
		if rooms.empty?
			return 0
		else
			rooms.to_a.sum { |room| room.number_of_adults * room.number_of_rooms }
		end
	end

	def number_of_children_between_5_and_12_years
		if rooms.empty?
			return 0
		else
			rooms.to_a.sum { |room| 
				room.number_of_children_between_5_and_12_years * room.number_of_rooms }
		end
	end

	def number_of_rooms
		if rooms.empty?
			return 0
		else
			rooms.to_a.sum { |room| room.number_of_rooms }
		end
	end

	def total_price
		if bookings.empty?
			return 0
		else
			bookings.to_a.sum { |booking| booking.total_price }
		end
	end

	def paid
		if payments.empty?
			return 0
		else
			payments.to_a.sum { |payment| payment.amount }
		end
	end

	def balance_payment
		final_price - paid
	end

	def final_price
		total_price - discount
	end

	def get_payment_status
		if balance_payment <= 0
			payment_status = 'Fully Paid'
		else
			if paid > 0
				payment_status = 'Partially Paid'
			else
				payment_status = 'Blocked'
			end
		end
		return payment_status
	end

	def long_name
		guest.name + ' - ' + name
	end

	private

		def ensure_guest_exists
			begin
				guest = Guest.find(guest_id)
			rescue ActiveRecord::RecordNotFound
				errors.add(:base, "Could not create Trip as Guest '#{guest_id}' does not exist")
				return false
			else
				return true
			end
		end	

		def set_defaults_if_nil
			self.number_of_children_below_5_years ||= 0
			self.number_of_drivers ||= 0
			self.discount ||= 0
			self.payment_status ||= 'Blocked'
		end

		def ensure_not_referenced_by_booking
			if bookings.empty?
				return true
			else
				errors.add(:base, "Destroy failed because the trip '#{name}' has bookings. Please destroy the bookings first.")
				return false
			end
		end

		def ensure_end_date_is_greater_than_start_date
			if end_date <= start_date
				errors.add(:base, "Could not create Trip as end date is earlier than start date")
				return false
			end
		end
end

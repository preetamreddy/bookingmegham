class Trip < ActiveRecord::Base
	belongs_to :guest

	has_many :rooms
	accepts_nested_attributes_for :rooms, :allow_destroy => true

	has_many :bookings

	before_save :ensure_guest_exists

	before_destroy :ensure_not_referenced_by_booking

	validates :guest_id, :name, :start_date, :end_date, presence: true

	validates_numericality_of :guest_id,
						only_integer: true, greater_than: 0, allow_nil: true,
						message: "should be a number greater than 0"

	validates_numericality_of :number_of_children_below_5_years, 
						:number_of_drivers,
						only_integer: true, greater_than_or_equal_to: 0, allow_nil: true,
						message: "should be a number greater than or equal to 0"

	def ensure_not_referenced_by_booking
		if bookings.empty?
			return true
		else
			errors.add(:base, "Destroy failed because the trip '#{name}' has bookings. Please destroy the bookings first.")
			return false
		end
	end

	def number_of_adults
		if rooms.empty?
			return nil
		else
			rooms.to_a.sum { |room| room.number_of_adults * room.number_of_rooms }
		end
	end

	def number_of_children_between_5_and_12_years
		if rooms.empty?
			return nil
		else
			rooms.to_a.sum { |room| 
				room.number_of_children_between_5_and_12_years * room.number_of_rooms }
		end
	end

	def number_of_rooms
		if rooms.empty?
			return nil
		else
			rooms.to_a.sum { |room| room.number_of_rooms }
		end
	end

	def Trip.update_roll_up_attributes(id)
		trip = Trip.find(id)
		trip.total_price = trip.compute_total_price
		trip.save!
	end

	def compute_total_price
		if bookings.empty?
			return nil
		else
			cumulated_total_price_from_bookings = bookings.to_a.sum { |booking| booking.total_price }
			return cumulated_total_price_from_bookings
		end
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
end

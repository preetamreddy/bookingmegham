class Booking < ActiveRecord::Base
	versioned :dependent => :tracking

	belongs_to :trip
	belongs_to :room_type

	has_many :rooms, dependent: :destroy
	accepts_nested_attributes_for :rooms, :reject_if => :all_blank,
		:allow_destroy => true

	has_many :line_items, dependent: :destroy

	before_save :ensure_trip_exists, :ensure_room_type_exists
	after_save :update_line_items

	validates :trip_id, :room_type_id, :check_in_date, :check_out_date,
											presence: true

	validates_numericality_of :trip_id, :room_type_id,
														only_integer: true, greater_than: 0, 
														allow_nil: true, 
														message: "should be a number greater than 0"

	validates_numericality_of :number_of_children_below_5_years,
														:number_of_drivers, :total_price,
														only_integer: true, greater_than_or_equal_to: 0,
														allow_nil: true, 
														message: "should be a number greater than or equal to 0"

	def add_rooms_from_trip(trip)
		trip.rooms.each do |trip_room|
			rooms.build(occupancy: trip_room.occupancy,
									number_of_adults: trip_room.number_of_adults,
									number_of_children_between_5_and_12_years: 
										trip_room.number_of_children_between_5_and_12_years,
									number_of_rooms: trip_room.number_of_rooms)
		end
	end

	def initialize_attributes_when_nil
		rooms.each do |room|
			if !room.number_of_children_between_5_and_12_years
				room.number_of_children_between_5_and_12_years = 0 
			end
		end
	end

	def update_room_rate
		rooms.each do |room|
			room.room_rate = RoomType.price(room_type_id, room.occupancy,
													room.number_of_adults,
													room.number_of_children_between_5_and_12_years)
		end
	end

	def update_total_price
		price_per_night = rooms.to_a.sum { |room|
			room.room_rate * room.number_of_rooms }
		number_of_days = (check_out_date - check_in_date).to_i
		self.total_price = price_per_night * number_of_days
	end

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

	private

		def ensure_trip_exists
			begin
				trip = Trip.find(trip_id)
			rescue ActiveRecord::RecordNotFound
				errors.add(:base, "Could not create Booking as Trip '#{trip_id}' does not exist")
				return false
 			else
        return true
			end
		end

		def ensure_room_type_exists
			begin
				room_type = RoomType.find(room_type_id)
			rescue ActiveRecord::RecordNotFound
				errors.add(:base, "Could not create Booking as Room Type '#{room_type_id}' does not exist")
				return false
 			else
        return true
			end
		end

		def update_line_items
			if line_items.any?
				delete_line_items
			end

			if rooms.any?
				add_line_items
			end	
		end

		def add_line_items
			date = check_in_date
			while date < check_out_date do
				rooms.each do |room|
					line_item = line_items.build(room_type_id: room_type_id,
												date: date,
												booked_rooms: room.number_of_rooms)
					line_item.save!
				end
				date += 1
			end
		end

		def delete_line_items
			line_items.destroy_all
		end
end

class Booking < ActiveRecord::Base
	versioned :dependent => :tracking

	belongs_to :trip
	belongs_to :room_type

	has_many :line_items, dependent: :destroy

	before_save :ensure_trip_exists, :ensure_room_type_exists
	after_save :create_line_items, :update_roll_up_attributes_for_the_trip

	after_destroy :update_roll_up_attributes_for_the_trip

	validates :trip_id, :room_type_id, :number_of_rooms, :number_of_adults, 
											:check_in_date, :check_out_date, :total_price,
											presence: true

	validates_numericality_of :trip_id, :room_type_id, :number_of_rooms,
														:number_of_adults,
														only_integer: true, greater_than: 0, 
														allow_nil: true, 
														message: "should be a number greater than 0"

	validates_numericality_of :number_of_children_between_5_and_12_years,
														:number_of_children_below_5_years, :total_price,
														only_integer: true, greater_than_or_equal_to: 0,
														allow_nil: true, 
														message: "should be a number greater than or equal to 0"

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

		def update_roll_up_attributes_for_the_trip
			Trip.update_roll_up_attributes(trip_id)
		end

		def create_line_items
			date = check_in_date
			delete_line_items
			while date < check_out_date do
				line_item = line_items.build(room_type_id: room_type_id,
											date: date,
											booked_rooms: number_of_rooms)
				line_item.save!
				date += 1
			end
		end

		def delete_line_items
			line_items.destroy_all
		end
end

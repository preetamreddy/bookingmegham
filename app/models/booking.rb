class Booking < ActiveRecord::Base
	versioned :dependent => :tracking

	belongs_to :room_type
	belongs_to :trip

	has_many :line_items, dependent: :destroy
	
	validates :trip_id, :room_type_id, :number_of_rooms,
						:number_of_adults, :number_of_children_between_5_and_12_years,
						:number_of_children_below_5_years, :check_in_date, :check_out_date,
						:total_price,
						presence: true
	validates_numericality_of :trip_id, :number_of_rooms, 
														:number_of_adults, :room_type_id,
														only_integer: true, greater_than: 0, 
														allow_nil: true, 
														message: "should be a number greater than 0"
	validates_numericality_of :number_of_children_between_5_and_12_years,
														:number_of_children_below_5_years,
														:total_price,
														only_integer: true, greater_than_or_equal_to: 0,
														allow_nil: true, 
														message: "should be a positive number or zero"

	after_save :update_trip_roll_up_attributes
	after_destroy :update_trip_roll_up_attributes

	def create_line_items
		date = check_in_date
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

	def update_line_items
		line_items.destroy_all
		create_line_items
	end

	def calculate_total_price
		return true	
	end

	private

		def update_trip_roll_up_attributes
			Trip.update_roll_up_attributes(trip_id)
		end

end

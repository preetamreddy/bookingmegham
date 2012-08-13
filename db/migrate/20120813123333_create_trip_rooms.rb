class CreateTripRooms < ActiveRecord::Migration
  def up
    create_table :trip_rooms do |t|
			t.integer :trip_id
      t.string :occupancy
			t.integer :number_of_rooms
			t.integer :number_of_adults
			t.integer :number_of_children_between_5_and_12_years
			t.integer :number_of_children_below_5_years, :default => 0
			t.integer :account_id

      t.timestamps
    end

		Room.all.each do |room|
			if room.trip_id
				TripRoom.create(:trip_id => room.trip_id,
					:occupancy => room.occupancy,
					:number_of_rooms => room.number_of_rooms,
					:number_of_adults => room.number_of_adults,
					:number_of_children_between_5_and_12_years => room.number_of_children_between_5_and_12_years,
					:number_of_children_below_5_years => room.number_of_children_below_5_years,
					:account_id => room.account_id,
					:created_at => room.created_at,
					:updated_at => room.updated_at)
				room.destroy
			end
		end
  end

	def down
		TripRoom.all.each do |trip_room|
			Room.create(:trip_id => trip_room.trip_id,
				:occupancy => trip_room.occupancy,
				:number_of_rooms => trip_room.number_of_rooms,
				:number_of_adults => trip_room.number_of_adults,
				:number_of_children_between_5_and_12_years => trip_room.number_of_children_between_5_and_12_years,
				:number_of_children_below_5_years => trip_room.number_of_children_below_5_years,
				:account_id => trip_room.account_id,
				:created_at => trip_room.created_at,
				:updated_at => trip_room.updated_at)
			trip_room.destroy
		end

		drop_table :trip_rooms
	end
end

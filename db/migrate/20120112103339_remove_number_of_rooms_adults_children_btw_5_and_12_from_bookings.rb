class RemoveNumberOfRoomsAdultsChildrenBtw5And12FromBookings < ActiveRecord::Migration
  def up
		remove_column :bookings, :number_of_rooms, :number_of_adults,
			:number_of_children_between_5_and_12_years
  end

	def down
		add_column :bookings, :number_of_rooms, :number_of_adults,
			:number_of_children_between_5_and_12_years, :integer
	end
end

class AddTotalPriceToTrips < ActiveRecord::Migration
	def up
		add_column :trips, :total_price, :integer, :default => 0

		Trip.all.each do |trip|
			trip.update_column(:total_price, 
				trip.price_for_vas + trip.price_for_transport + trip.price_for_rooms - trip.discount - trip.tac)
		end
	end

	def down
		remove_column :trips, :total_price
	end
end

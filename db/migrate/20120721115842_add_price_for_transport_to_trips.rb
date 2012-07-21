class AddPriceForTransportToTrips < ActiveRecord::Migration
  def up
    add_column :trips, :price_for_transport, :integer, :default => 0

		Trip.all.each do |trip|
			if trip.taxi_bookings.any?
				trip.update_column(:price_for_transport, 
					trip.taxi_bookings.to_a.sum { |taxi_booking| taxi_booking.total_price } )
			end
		end
  end

	def down
    remove_column :trips, :price_for_transport
	end
end

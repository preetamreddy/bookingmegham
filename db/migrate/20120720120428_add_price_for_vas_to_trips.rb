class AddPriceForVasToTrips < ActiveRecord::Migration
  def up
    add_column :trips, :price_for_vas, :integer, :default => 0

		Trip.all.each do |trip|
			if trip.vas_bookings.any?
				trip.update_column(:price_for_vas, 
					trip.vas_bookings.to_a.sum { |vas_booking| vas_booking.total_price } )
			end
		end
  end

	def down
    remove_column :trips, :price_for_vas
	end
end

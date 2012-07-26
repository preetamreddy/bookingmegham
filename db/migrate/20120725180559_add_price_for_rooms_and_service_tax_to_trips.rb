class AddPriceForRoomsAndServiceTaxToTrips < ActiveRecord::Migration
  def up
    add_column :trips, :price_for_rooms, :integer, :default => 0
    add_column :trips, :service_tax, :integer, :default => 0

		Trip.all.each do |trip|
			if trip.bookings.any?
				trip.update_column(:price_for_rooms,
					trip.bookings.to_a.sum { |room_booking| room_booking.total_price } )
				trip.update_column(:service_tax,
					trip.bookings.to_a.sum { |room_booking| room_booking.service_tax } )
			end
		end
  end

	def down
    remove_column :trips, :price_for_rooms
    remove_column :trips, :service_tax
	end
end

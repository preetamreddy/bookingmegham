class AddPriceForVasToBookings < ActiveRecord::Migration
  def up
    add_column :bookings, :price_for_vas, :integer, :default => 0

		Booking.all.each do |booking|
			if booking.vas_bookings.any?
				booking.update_column(:price_for_vas, 
					booking.vas_bookings.to_a.sum { |vas_booking| vas_booking.total_price } )
			end
		end
  end

	def down
    remove_column :bookings, :price_for_vas
	end
end

class AddTotalPriceToTaxiBookings < ActiveRecord::Migration
  def up
    add_column :taxi_bookings, :total_price, :integer

		TaxiBooking.all.each do |taxi_booking|
			taxi_booking.total_price = taxi_booking.unit_price * taxi_booking.number_of_vehicles *
																	taxi_booking.number_of_days
			taxi_booking.save!
		end
  end

	def down
    remove_column :taxi_bookings, :total_price
	end
end

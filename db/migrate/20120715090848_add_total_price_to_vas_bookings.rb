class AddTotalPriceToVasBookings < ActiveRecord::Migration
  def up
    add_column :vas_bookings, :total_price, :integer

		VasBooking.all.each do |vas_booking|
			vas_booking.update_column(:total_price, 
				vas_booking.unit_price * vas_booking.number_of_units)
		end
  end

  def down
    remove_column :vas_bookings, :total_price
  end
end

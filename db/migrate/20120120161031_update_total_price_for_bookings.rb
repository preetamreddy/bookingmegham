class UpdateTotalPriceForBookings < ActiveRecord::Migration
  def up
		Booking.all.each do |booking|
			booking.update_total_price
			booking.save!
		end
  end
end

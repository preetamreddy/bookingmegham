class SetDefaultForTotalPriceInVasBookings < ActiveRecord::Migration
  def up
		change_column_default :vas_bookings, :total_price, 0
  end

  def down
		change_column_default :vas_bookings, :total_price, nil
  end
end

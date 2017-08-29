class AddDiscountPercentageToVasBookings < ActiveRecord::Migration
  def change
    add_column :vas_bookings, :discount_percentage, :float, :default => 0.0
  end
end

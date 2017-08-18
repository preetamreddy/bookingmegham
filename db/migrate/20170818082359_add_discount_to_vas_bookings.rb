class AddDiscountToVasBookings < ActiveRecord::Migration
  def change
    add_column :vas_bookings, :discount, :integer, :default => 0
  end
end

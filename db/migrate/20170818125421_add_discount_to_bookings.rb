class AddDiscountToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :discount, :integer, :default => 0
  end
end

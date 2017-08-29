class AddDiscountPercentageToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :discount_percentage, :float, :default => 0.0
  end
end

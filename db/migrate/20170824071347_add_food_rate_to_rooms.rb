class AddFoodRateToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :food_rate, :integer, :default => 0
  end
end

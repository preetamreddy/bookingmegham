class AddPriceForFoodOnDoubleToRoomTypes < ActiveRecord::Migration
  def change
    add_column :room_types, :price_for_food_on_double, :integer, :default => 0
  end
end

class AddPriceForFoodOnSingleToRoomTypes < ActiveRecord::Migration
  def change
    add_column :room_types, :price_for_food_on_single, :integer, :default => 0
  end
end

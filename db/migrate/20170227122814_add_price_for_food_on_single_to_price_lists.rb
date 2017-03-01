class AddPriceForFoodOnSingleToPriceLists < ActiveRecord::Migration
  def change
    add_column :price_lists, :price_for_food_on_single, :integer, :default => 0
  end
end

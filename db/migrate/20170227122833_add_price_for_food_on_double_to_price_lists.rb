class AddPriceForFoodOnDoubleToPriceLists < ActiveRecord::Migration
  def change
    add_column :price_lists, :price_for_food_on_double, :integer, :default => 0
  end
end

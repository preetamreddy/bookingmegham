class AddPriceForFoodTransportationAndGuideToPriceLists < ActiveRecord::Migration
  def change
    add_column :price_lists, :price_for_transportation_and_guide, :integer, :default => 0
  end
end

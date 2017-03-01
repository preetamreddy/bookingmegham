class AddPriceForLodgingToPriceLists < ActiveRecord::Migration
  def change
    add_column :price_lists, :price_for_lodging, :integer, :default => 0
  end
end

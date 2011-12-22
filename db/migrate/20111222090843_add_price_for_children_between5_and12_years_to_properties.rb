class AddPriceForChildrenBetween5And12YearsToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :price_for_children_between_5_and_12_years, :integer
  end
end

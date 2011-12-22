class RemovePriceForChildrenBelow12YearsFromProperty < ActiveRecord::Migration
  def up
    remove_column :properties, :price_for_children_below_12_years
  end

  def down
    add_column :properties, :price_for_children_below_12_years, :integer
  end
end

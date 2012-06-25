class RemoveGuestPriceInfoFromProperties < ActiveRecord::Migration
  def up
		remove_column :properties, [:price_for_triple_occupancy,
			:price_for_children_below_5_years,
			:price_for_children_between_5_and_12_years]
  end

  def down
		add_column :properties, :price_for_triple_occupancy, :integer
		add_column :properties, :price_for_children_below_5_years, :integer
		add_column :properties, :price_for_children_between_5_and_12_years, :integer
  end
end

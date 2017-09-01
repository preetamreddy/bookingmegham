class AddPriceForLodgingOnDoubleToPriceLists < ActiveRecord::Migration
	def up
		add_column :price_lists, :price_for_lodging_on_double, :integer, :default => 0

		PriceList.all.each do |price_list|
			price_list.update_column(:price_for_lodging_on_double, price_list.price_for_lodging)
		end
	end

	def down
		remove_column :price_lists, :price_for_lodging_on_double
	end
end

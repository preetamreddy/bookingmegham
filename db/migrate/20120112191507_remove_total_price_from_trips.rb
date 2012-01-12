class RemoveTotalPriceFromTrips < ActiveRecord::Migration
  def up
		remove_column :trips, :total_price
  end

  def down
		add_column :trips, :total_price, :integer
  end
end

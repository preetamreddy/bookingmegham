class DropTableVasPrices < ActiveRecord::Migration
  def up
		drop_table :vas_prices
  end

  def down
    create_table :vas_prices do |t|
      t.integer :value_added_service_id
      t.integer :unit_price
      t.integer :min_group_size
      t.integer :max_group_size
      t.timestamps
    end
  end
end

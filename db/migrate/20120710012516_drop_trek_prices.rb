class DropTrekPrices < ActiveRecord::Migration
  def up
		drop_table :trek_prices
  end

  def down
    create_table :trek_prices do |t|
      t.integer :trek_id
      t.integer :unit_price
      t.integer :min_group_size
      t.integer :max_group_size
      t.integer :account_id

      t.timestamps
    end

		add_index "trek_prices", ["account_id"], :name => "index_trek_prices_on_account_id"
  end
end

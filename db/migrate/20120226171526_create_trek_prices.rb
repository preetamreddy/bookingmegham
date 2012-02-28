class CreateTrekPrices < ActiveRecord::Migration
  def change
    create_table :trek_prices do |t|
      t.integer :trek_id
      t.integer :unit_price
      t.integer :min_group_size
      t.integer :max_group_size

      t.timestamps
    end
  end
end

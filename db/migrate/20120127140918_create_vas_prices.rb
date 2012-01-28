class CreateVasPrices < ActiveRecord::Migration
  def change
    create_table :vas_prices do |t|
      t.integer :value_added_service_id
      t.integer :unit_price
      t.integer :min_group_size
      t.integer :max_group_size

      t.timestamps
    end
  end
end

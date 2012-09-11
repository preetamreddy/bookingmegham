class CreatePriceLists < ActiveRecord::Migration
  def change
    create_table :price_lists do |t|
      t.integer :room_type_id
      t.integer :account_id
      t.integer :price_for_single_occupancy, :default => 0
      t.integer :price_for_double_occupancy, :default => 0
      t.integer :price_for_extra_adults, :default => 0
      t.integer :price_for_children, :default => 0
      t.integer :price_for_infants, :default => 0
      t.string :meal_plan
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end

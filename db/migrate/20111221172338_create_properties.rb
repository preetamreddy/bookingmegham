class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :name
      t.integer :price_for_children_below_12_years
      t.integer :price_for_children_below_5_years
      t.integer :price_for_triple_occupancy
      t.integer :price_for_driver
      t.text :description

      t.timestamps
    end
  end
end

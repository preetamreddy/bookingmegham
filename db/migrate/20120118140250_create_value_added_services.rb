class CreateValueAddedServices < ActiveRecord::Migration
  def change
    create_table :value_added_services do |t|
      t.integer :property_id
      t.string :name
      t.integer :unit_price
      t.text :description

      t.timestamps
    end
  end
end

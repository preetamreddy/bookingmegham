class DropValueAddedServices < ActiveRecord::Migration
  def up
		drop_table :value_added_services
  end

  def down
    create_table :value_added_services do |t|
      t.integer :property_id
      t.string :name
      t.integer :unit_price, :default => 0
      t.text :description
    	t.integer :min_people, :default => 1
    	t.integer :account_id

      t.timestamps
    end

		add_index "value_added_services", ["account_id"], :name => "index_value_added_services_on_account_id"
  end
end

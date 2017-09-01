class AddForOwnPropertiesToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :for_own_properties, :integer, :default => 1
  end
end

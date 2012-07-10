class RemoveNumberOfTrekkersFromTrips < ActiveRecord::Migration
  def up
    remove_column :trips, :number_of_trekkers
  end

  def down
    add_column :trips, :number_of_trekkers, :integer, :default => 0
  end
end

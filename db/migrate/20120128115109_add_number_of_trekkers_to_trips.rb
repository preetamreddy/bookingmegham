class AddNumberOfTrekkersToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :number_of_trekkers, :integer, :default => 0
  end
end

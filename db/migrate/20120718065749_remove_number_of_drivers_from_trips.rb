class RemoveNumberOfDriversFromTrips < ActiveRecord::Migration
  def up
		remove_column :trips, :number_of_drivers
  end

  def down
		add_column :trips, :number_of_drivers, :integer
  end
end

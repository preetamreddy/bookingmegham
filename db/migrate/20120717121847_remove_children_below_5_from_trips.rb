class RemoveChildrenBelow5FromTrips < ActiveRecord::Migration
  def up
		remove_column :trips, :number_of_children_below_5_years
  end

  def down
		add_column :trips, :number_of_children_below_5_years, :integer
  end
end

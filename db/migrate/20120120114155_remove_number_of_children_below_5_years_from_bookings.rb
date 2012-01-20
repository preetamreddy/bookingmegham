class RemoveNumberOfChildrenBelow5YearsFromBookings < ActiveRecord::Migration
  def up
		remove_column :bookings, :number_of_children_below_5_years
  end

  def down
		add_column :bookings, :number_of_children_below_5_years, :integer
  end
end

class AddNumberOfChildrenBelow5YearsToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :number_of_children_below_5_years, :integer, :default => 0
  end
end

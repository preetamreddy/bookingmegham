class RemoveNumberOfChildrenFromBooking < ActiveRecord::Migration
  def up
    remove_column :bookings, :number_of_children
  end

  def down
    add_column :bookings, :number_of_children, :integer
  end
end

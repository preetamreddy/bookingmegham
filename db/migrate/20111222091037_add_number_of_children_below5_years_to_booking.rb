class AddNumberOfChildrenBelow5YearsToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :number_of_children_below_5_years, :integer
  end
end

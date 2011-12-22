class AddNumberOfChildrenBetween5And12YearsToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :number_of_children_between_5_and_12_years, :integer
  end
end

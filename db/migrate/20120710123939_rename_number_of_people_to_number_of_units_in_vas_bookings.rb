class RenameNumberOfPeopleToNumberOfUnitsInVasBookings < ActiveRecord::Migration
  def up
		rename_column :vas_bookings, :number_of_people, :number_of_units
  end

  def down
		rename_column :vas_bookings, :number_of_units, :number_of_people
  end
end

class RemoveNumberOfInfantsFromBooking < ActiveRecord::Migration
  def up
    remove_column :bookings, :number_of_infants
  end

  def down
    add_column :bookings, :number_of_infants, :integer
  end
end

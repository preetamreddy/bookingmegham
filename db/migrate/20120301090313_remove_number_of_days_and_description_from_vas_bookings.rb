class RemoveNumberOfDaysAndDescriptionFromVasBookings < ActiveRecord::Migration
  def up
		remove_column :vas_bookings, :number_of_days
		remove_column :vas_bookings, :description
  end

  def down
		add_column :vas_bookings, :number_of_days, :integer
		add_column :vas_bookings, :description, :string
  end
end

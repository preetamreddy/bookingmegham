class RemoveRemarksFromTaxiBookings < ActiveRecord::Migration
  def up
		remove_column :taxi_bookings, :remarks
  end

  def down
		add_column :taxi_bookings, :remarks, :text
  end
end

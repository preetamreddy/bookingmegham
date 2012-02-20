class RenameColumnNotesToRemarksInBookings < ActiveRecord::Migration
  def up
		rename_column :bookings, :notes, :remarks
  end

  def down
		rename_column :bookings, :remarks, :notes
  end
end

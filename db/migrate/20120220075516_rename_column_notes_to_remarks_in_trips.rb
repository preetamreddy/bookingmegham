class RenameColumnNotesToRemarksInTrips < ActiveRecord::Migration
  def up
		rename_column :trips, :notes, :remarks
  end

  def down
		rename_column :trips, :remarks, :notes
  end
end

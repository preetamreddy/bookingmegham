class RenameCommentsToNotesInTrips < ActiveRecord::Migration
  def up
		rename_column :trips, :comments, :notes
  end

  def down
		rename_column :trips, :notes, :comments
  end
end

class RenameCommentsToNotesInBookings < ActiveRecord::Migration
  def up
		rename_column :bookings, :comments, :notes
  end

  def down
		rename_column :bookings, :notes, :comments
  end
end

class RenameResidentOfToCityInGuests < ActiveRecord::Migration
  def up
		rename_column :guests, :resident_of, :city
  end

  def down
		rename_column :guests, :city, :resident_of
  end
end

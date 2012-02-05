class RenameNameForReceiptsInTrips < ActiveRecord::Migration
  def up
		rename_column :trips, :name_for_receipts, :payee_name
  end

  def down
		rename_column :trips, :payee_name, :name_for_receipts
  end
end

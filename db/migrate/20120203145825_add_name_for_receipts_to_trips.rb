class AddNameForReceiptsToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :name_for_receipts, :string
  end
end

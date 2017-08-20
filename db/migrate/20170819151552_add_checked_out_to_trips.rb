class AddCheckedOutToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :checked_out, :integer, :default => 0
  end
end

class AddIgstToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :igst, :float, :default => 0.0
  end
end

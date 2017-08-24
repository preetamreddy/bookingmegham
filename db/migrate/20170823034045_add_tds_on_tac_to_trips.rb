class AddTdsOnTacToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :tds_on_tac, :integer, :default => 0
  end
end

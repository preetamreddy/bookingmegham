class AddTacToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :tac, :integer, :default => 0
  end
end

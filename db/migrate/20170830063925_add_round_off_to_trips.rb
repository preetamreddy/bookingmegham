class AddRoundOffToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :round_off, :integer, :default => 0
  end
end

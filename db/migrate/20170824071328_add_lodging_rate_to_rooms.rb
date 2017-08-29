class AddLodgingRateToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :lodging_rate, :integer, :default => 0
  end
end

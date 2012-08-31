class AddCancellationChargeToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :cancellation_charge, :integer, :default => 0
  end
end

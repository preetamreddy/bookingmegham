class AddGstRatesToRoomTypes < ActiveRecord::Migration
  def change
    add_column :room_types, :cgst_rate, :float, :default => 0.0
    add_column :room_types, :sgst_rate, :float, :default => 0.0
  end
end

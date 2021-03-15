class AddGstRateToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :cgst_rate, :float
    add_column :rooms, :sgst_rate, :float
  end
end

class AddGstTypeToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :gst_type, :string
  end
end

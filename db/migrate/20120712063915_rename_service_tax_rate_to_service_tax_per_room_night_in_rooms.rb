class RenameServiceTaxRateToServiceTaxPerRoomNightInRooms < ActiveRecord::Migration
  def up
		rename_column :rooms, :service_tax_rate, :service_tax_per_room_night
  end

  def down
		rename_column :rooms, :service_tax_per_room_night, :service_tax_rate
  end
end

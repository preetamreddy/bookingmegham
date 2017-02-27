class AddPriceForTransportationAndGuideToRoomTypes < ActiveRecord::Migration
  def change
    add_column :room_types, :price_for_transportation_and_guide, :integer, default: 0
  end
end

class AddExtraGuestPricesToRoomTypes < ActiveRecord::Migration
  def change
    add_column :room_types, :price_for_triple_occupancy, :integer, :default => 0
    add_column :room_types, :price_for_children_between_5_and_12_years, :integer, :default => 0
    add_column :room_types, :price_for_children_below_5_years, :integer, :default => 0
  end
end

class RemovePricingDefaultsFromRoomTypes < ActiveRecord::Migration
  def up
    change_column_default :room_types, :price_for_triple_occupancy, nil
    change_column_default :room_types, :price_for_children_between_5_and_12_years, nil
    change_column_default :room_types, :price_for_children_below_5_years, nil
  end

  def down
    change_column_default :room_types, :price_for_triple_occupancy, 0
    change_column_default :room_types, :price_for_children_between_5_and_12_years, 0
    change_column_default :room_types, :price_for_children_below_5_years, 0
  end
end

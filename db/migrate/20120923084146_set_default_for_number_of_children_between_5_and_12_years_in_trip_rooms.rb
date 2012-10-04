class SetDefaultForNumberOfChildrenBetween5And12YearsInTripRooms < ActiveRecord::Migration
  def up
    change_column_default :trip_rooms, :number_of_children_between_5_and_12_years, 0
  end

  def down
    change_column_default :trip_rooms, :number_of_children_between_5_and_12_years, nil
  end
end

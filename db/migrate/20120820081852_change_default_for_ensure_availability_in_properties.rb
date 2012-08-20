class ChangeDefaultForEnsureAvailabilityInProperties < ActiveRecord::Migration
  def up
    change_column_default :properties, :ensure_availability_before_booking, 0
  end

  def down
    change_column_default :properties, :ensure_availability_before_booking, 1
  end
end

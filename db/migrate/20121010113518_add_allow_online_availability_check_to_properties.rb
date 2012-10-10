class AddAllowOnlineAvailabilityCheckToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :allow_online_availability_check, :integer, :default => 0
  end
end

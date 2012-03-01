class RemoveIsTrekFromValueAddedServices < ActiveRecord::Migration
  def up
		remove_column :value_added_services, :is_trek
  end

  def down
    add_column :value_added_services, :is_trek, :integer, :default => 0
  end
end

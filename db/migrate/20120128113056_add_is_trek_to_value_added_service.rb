class AddIsTrekToValueAddedService < ActiveRecord::Migration
  def change
    add_column :value_added_services, :is_trek, :integer, :default => 0
  end
end

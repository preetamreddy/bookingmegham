class AddDiscountToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :discount, :integer, :default => 0
  end
end

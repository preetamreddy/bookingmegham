class AddTransportationAndGuideRateToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :transportation_and_guide_rate, :integer, :default => 0
  end
end

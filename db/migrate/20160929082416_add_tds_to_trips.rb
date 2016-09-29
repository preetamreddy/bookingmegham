class AddTdsToTrips < ActiveRecord::Migration
  def up
    add_column :trips, :tds, :integer, :default => 0

    Trip.all.each do |trip|
      trip.update_column(:tds, trip.tac * 0.1)
    end

  end

  def down
    remove_column :trips, :tds
  end
end

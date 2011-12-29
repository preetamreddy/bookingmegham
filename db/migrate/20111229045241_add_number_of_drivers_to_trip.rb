class AddNumberOfDriversToTrip < ActiveRecord::Migration
  def change
    add_column :trips, :number_of_drivers, :integer
  end
end

class AddNumberOfDaysToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :number_of_days, :integer
  end
end

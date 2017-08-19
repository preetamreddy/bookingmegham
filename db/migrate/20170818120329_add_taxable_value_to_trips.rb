class AddTaxableValueToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :taxable_value, :integer, :default => 0
  end
end

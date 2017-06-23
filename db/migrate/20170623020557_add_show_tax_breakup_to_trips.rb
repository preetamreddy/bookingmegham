class AddShowTaxBreakupToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :show_tax_breakup, :integer, default: 0
  end
end

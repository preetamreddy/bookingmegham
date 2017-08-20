class AddCounterForTaxInvoiceToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :counter_for_tax_invoice, :integer, :default => 0
  end
end

class AddInvoiceDateToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :invoice_date, :date
  end
end

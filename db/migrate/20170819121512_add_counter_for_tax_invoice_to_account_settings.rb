class AddCounterForTaxInvoiceToAccountSettings < ActiveRecord::Migration
  def change
    add_column :account_settings, :counter_for_tax_invoice, :integer, :default => 1
  end
end

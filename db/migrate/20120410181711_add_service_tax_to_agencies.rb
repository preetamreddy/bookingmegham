class AddServiceTaxToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :service_tax, :text, :default => "0"
  end
end

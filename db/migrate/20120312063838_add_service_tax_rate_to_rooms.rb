class AddServiceTaxRateToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :service_tax_rate, :integer
  end
end

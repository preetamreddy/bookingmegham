class RemoveGstRatesForHotelServicesFromAccountSettings < ActiveRecord::Migration
  def up
    remove_column :account_settings, :cgst_rate_for_hotel_services
    remove_column :account_settings, :sgst_rate_for_hotel_services
  end

  def down
    add_column :account_settings, :cgst_rate_for_hotel_services, :float, :default => 0.0
    add_column :account_settings, :sgst_rate_for_hotel_services, :float, :default => 0.0
  end
end

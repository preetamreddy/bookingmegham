class AddGstinAndGstRatesToAccountSettings < ActiveRecord::Migration
  def change
    add_column :account_settings, :gstin, :string
    add_column :account_settings, :cgst_rate_for_tour_operator_services, :float, :default => 0.0
    add_column :account_settings, :sgst_rate_for_tour_operator_services, :float, :default => 0.0
    add_column :account_settings, :cgst_rate_for_hotel_services, :float, :default => 0.0
    add_column :account_settings, :sgst_rate_for_hotel_services, :float, :default => 0.0
  end
end

class RemoveGstRatesForTourOperatorServicesFromProperties < ActiveRecord::Migration
  def up
    remove_column :properties, :cgst_rate_for_tour_operator_services
    remove_column :properties, :sgst_rate_for_tour_operator_services
  end

  def down
    add_column :properties, :cgst_rate_for_tour_operator_services, :float, :default => 0.0
    add_column :properties, :sgst_rate_for_tour_operator_services, :float, :default => 0.0
  end
end

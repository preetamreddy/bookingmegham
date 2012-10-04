class AddServiceTaxRateToProperties < ActiveRecord::Migration
  def up
    add_column :properties, :service_tax_rate, :float

    Property.all.each do |property|
      property.update_column(:service_tax_rate, property.str_old.to_f)
    end
  end

  def down
    remove_column :properties, :service_tax_rate
  end
end

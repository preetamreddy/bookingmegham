class AddServiceTaxEmailCityToProperties < ActiveRecord::Migration
  def up
    add_column :properties, :service_tax_rate, :string, :default => '0'
    add_column :properties, :email, :string
    add_column :properties, :city, :string

		Property.all.each do |property|
			agency = Agency.find(property.agency_id)
			if property.ensure_availability_before_booking == 1
				property.service_tax_rate = agency.service_tax
			end
			property.email = agency.email_id
			property.city = agency.city
			property.save!
		end
  end

	def down
    remove_column :properties, :service_tax_rate
    remove_column :properties, :email
    remove_column :properties, :city
	end
end

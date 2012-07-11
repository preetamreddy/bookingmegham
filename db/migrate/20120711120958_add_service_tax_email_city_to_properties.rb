class AddServiceTaxEmailCityToProperties < ActiveRecord::Migration
  def up
    add_column :properties, :service_tax, :string, :default => '0'
    add_column :properties, :email, :string
    add_column :properties, :city, :string

		Property.all.each do |property|
			if property.ensure_availability_before_booking == 1
				property.service_tax = property.agency.service_tax
			end
			property.email = property.agency.email_id
			property.city = property.agency.city
			property.save!
		end
  end

	def down
    remove_column :properties, :service_tax
    remove_column :properties, :email
    remove_column :properties, :city
	end
end

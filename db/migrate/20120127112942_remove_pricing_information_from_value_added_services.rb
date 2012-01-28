class RemovePricingInformationFromValueAddedServices < ActiveRecord::Migration
  def up
		remove_column :value_added_services, :unit_price
		remove_column :value_added_services, :minimum_people_required
		remove_column :value_added_services, :maximum_people
  end

  def down
		add_column :value_added_services, :unit_price, :integer
		add_column :value_added_services, :minimum_people_required, :integer
		add_column :value_added_services, :maximum_people, :integer
  end
end

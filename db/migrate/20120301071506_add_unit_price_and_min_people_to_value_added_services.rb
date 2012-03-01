class AddUnitPriceAndMinPeopleToValueAddedServices < ActiveRecord::Migration
  def change
    add_column :value_added_services, :unit_price, :integer, :default => 0
    add_column :value_added_services, :min_people, :integer, :default => 1
  end
end

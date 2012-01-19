class AddMinAndMaxNumberOfPeopleToValueAddedServices < ActiveRecord::Migration
  def change
    add_column :value_added_services, :minimum_people_required, :integer
    add_column :value_added_services, :maximum_people, :integer
  end
end

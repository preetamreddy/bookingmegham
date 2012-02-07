class UpdateAgencyIdInProperties < ActiveRecord::Migration
  def up
		Property.all.each do |property|
			property.agency_id = Agency.find_by_name('Banjara Camps and Retreats').id
			property.save!
		end
  end

  def down
		Property.all.each do |property|
			property.agency_id = nil
			property.save!
		end
  end
end

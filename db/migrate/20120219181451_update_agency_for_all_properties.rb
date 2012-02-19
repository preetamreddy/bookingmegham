class UpdateAgencyForAllProperties < ActiveRecord::Migration
  def up
		Property.all.each do |p|
			p.agency_id = Agency.find_by_name('Banjara Camps and Retreats').id
			p.save!
		end
  end

  def down
		Property.all.each do |p|
			p.agency_id = nil
			p.save!
		end
  end
end

class UpdateAgencyIdInUsers < ActiveRecord::Migration
  def up
		User.all.each do |user|
			user.agency_id = user.advisor.agency.id
			user.save!
		end
  end

  def down
		User.all.each do |user|
			user.agency_id = nil
			user.save!
		end
  end
end

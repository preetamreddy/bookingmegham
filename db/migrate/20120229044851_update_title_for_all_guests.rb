class UpdateTitleForAllGuests < ActiveRecord::Migration
  def up
		Guest.all.each do |guest|
			guest.title = "Mr"
			guest.save
		end
  end

  def down
		Guest.all.each do |guest|
			guest.title = ""
			guest.save
		end
  end
end

class RemoveOtherInformationFromGuests < ActiveRecord::Migration
  def up
		remove_column :guests, :other_information
  end

  def down
		add_column :guests, :other_information, :text
  end
end

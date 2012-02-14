class RemoveOtherInformationFromAgencies < ActiveRecord::Migration
  def up
		remove_column :agencies, :other_information
  end

  def down
		add_column :agencies, :other_information, :text
  end
end

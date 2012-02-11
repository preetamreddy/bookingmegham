class ChangeDatatypeOfPhoneNumberColsInAgencies < ActiveRecord::Migration
  def up
		change_column :agencies, :phone_number, :bigint
  end

  def down
		change_column :agencies, :phone_number, :integer
  end
end

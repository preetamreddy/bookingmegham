class ChangeDatatypeOfPhoneNumberColsToStringInAgencies < ActiveRecord::Migration
  def up
		change_column :agencies, :phone_number, :string
  end

  def down
		change_column :agencies, :phone_number, :bigint
  end
end

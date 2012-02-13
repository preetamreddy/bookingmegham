class ChangeDatatypeOfPhoneNumberColsToStringInAdvisors < ActiveRecord::Migration
  def up
		change_column :advisors, :phone_number_1, :string
		change_column :advisors, :phone_number_2, :string
  end

  def down
		change_column :advisors, :phone_number_1, :bigint
		change_column :advisors, :phone_number_2, :bigint
  end
end

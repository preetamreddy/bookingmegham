class ChangeDatatypeOfPhoneNumberColsInAdvisors < ActiveRecord::Migration
  def up
		change_column :advisors, :phone_number_1, :bigint
		change_column :advisors, :phone_number_2, :bigint
  end

  def down
		change_column :advisors, :phone_number_1, :integer
		change_column :advisors, :phone_number_2, :integer
  end
end

class ChangeDatatypeOfPhoneNumberColsToStringInGuests < ActiveRecord::Migration
  def up
		change_column :guests, :phone_number, :string
  end

  def down
		change_column :guests, :phone_number, :bigint
  end
end

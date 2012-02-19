class AddPhoneNumberAndPhoneNumber2AndAddressToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :phone_number, :string
    add_column :properties, :phone_number_2, :string
    add_column :properties, :address, :text
  end
end

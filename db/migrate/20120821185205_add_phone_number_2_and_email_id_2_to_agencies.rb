class AddPhoneNumber2AndEmailId2ToAgencies < ActiveRecord::Migration
  def change
    add_column :agencies, :phone_number_2, :string
    add_column :agencies, :email_id_2, :string
  end
end

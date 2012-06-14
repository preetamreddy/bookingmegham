class AddUserConfirmable < ActiveRecord::Migration
  def up
		## Confirmable
		add_column :users, :confirmation_token, :string
		add_column :users, :confirmed_at, :datetime
		add_column :users, :confirmation_sent_at, :datetime

		User.update_all({:confirmed_at => DateTime.now, :confirmation_token => "Grandfathered Account",
											:confirmation_sent_at => DateTime.now})
  end

  def down
		remove_column :users, [:confirmed_at, :confirmation_token, :confirmation_sent_at]
  end
end

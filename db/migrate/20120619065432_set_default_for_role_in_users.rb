class SetDefaultForRoleInUsers < ActiveRecord::Migration
  def up
		change_column_default :users, :role, 'advisor'
  end

  def down
		change_column_default :users, :role, nil
  end
end

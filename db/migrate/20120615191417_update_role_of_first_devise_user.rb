class UpdateRoleOfFirstDeviseUser < ActiveRecord::Migration
  def up
		user = User.find_by_email('preetam@ezbook.in')
		user.role = 'super_admin'
		user.password = 'testing'
		user.password_confirmation = 'testing'
		user.save!
  end

  def down
		user = User.find_by_email('preetam@ezbook.in')
		user.role = ''
		user.password = 'testing'
		user.password_confirmation = 'testing'
		user.save!
  end
end

class CreateFirstDeviseUser < ActiveRecord::Migration
  def up
		user = User.new
		user.email = 'preetam@ezbook.in'
		user.password = 'testing'
		user.password_confirmation = 'testing'
		user.created_at = '2012-06-08 09:23:40.363486'
		user.updated_at = '2012-06-08 10:59:08.667153'
		user.agency_id = 1
		user.advisor_id = Advisor.find_by_name('Preetam Reddy').id
		user.name = 'preetam'
		user.save!
  end

  def down
		user = User.find_by_email('preetam@ezbook.in')
		user.destroy
  end
end

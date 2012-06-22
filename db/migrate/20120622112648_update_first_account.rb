class UpdateFirstAccount < ActiveRecord::Migration
  def up
		banjara = Account.find_by_subdomain('banjaracamps')
		banjara.name = 'Banjara Camps And Retreats Pvt. Ltd.'
		banjara.save
  end

  def down
		banjara = Account.find_by_subdomain('banjaracamps')
		banjara.name = 'Banjara Camps and Retreats Pvt. Ltd.'
		banjara.save
  end
end

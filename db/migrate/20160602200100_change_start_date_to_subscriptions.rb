class ChangeStartDateToSubscriptions < ActiveRecord::Migration
  def change
  	change_column :subscriptions, :start_date, :datetime
  end
end

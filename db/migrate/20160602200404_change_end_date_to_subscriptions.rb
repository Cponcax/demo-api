class ChangeEndDateToSubscriptions < ActiveRecord::Migration
  def change
      change_column :subscriptions, :end_date, :datetime
  end
end

class AddStartTimeToReminders < ActiveRecord::Migration
  def change
  	add_column :reminders, :start_time, :datetime
  end
end


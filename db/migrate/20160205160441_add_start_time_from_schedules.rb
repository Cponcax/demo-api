class AddStartTimeFromSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :start_time, :date
  end
end

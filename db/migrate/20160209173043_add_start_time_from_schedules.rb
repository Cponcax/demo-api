class AddStartTimeFromSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :start, :time
  end
end

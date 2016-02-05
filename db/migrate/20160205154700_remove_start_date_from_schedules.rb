class RemoveStartDateFromSchedules < ActiveRecord::Migration
  def change
    remove_column :schedules, :start_date, :date
  end
end

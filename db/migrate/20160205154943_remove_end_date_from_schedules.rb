class RemoveEndDateFromSchedules < ActiveRecord::Migration
  def change
    remove_column :schedules, :end_date, :date
  end
end

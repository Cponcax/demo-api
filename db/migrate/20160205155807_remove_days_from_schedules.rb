class RemoveDaysFromSchedules < ActiveRecord::Migration
  def change
    remove_column :schedules, :days, :integer
  end
end

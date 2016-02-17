class ChangeEndTimeToEvents < ActiveRecord::Migration
  def change
  	change_column :events, :end_time, :time
  end
end

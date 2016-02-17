class ChangeStartTimeToEvents < ActiveRecord::Migration
  def change
  	change_column :events, :start_time, :time
  end
end

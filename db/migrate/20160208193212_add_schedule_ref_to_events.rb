class AddScheduleRefToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :schedule, index: true, foreign_key: true
  end
end

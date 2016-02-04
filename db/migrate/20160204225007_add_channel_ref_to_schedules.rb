class AddChannelRefToSchedules < ActiveRecord::Migration
  def change
    add_reference :schedules, :channel, index: true, foreign_key: true
  end
end

class AddTurnToSchedules < ActiveRecord::Migration
  def change
    add_column :schedules, :turn, :string
  end
end

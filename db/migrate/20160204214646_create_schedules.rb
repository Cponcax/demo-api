class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :channel, index: true
      t.date :date
      t.string :name
      t.string :turn

      t.timestamps null: false
    end
    
  end
end

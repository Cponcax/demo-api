class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.references :user, index: true
      t.references :channel, index: true
      t.references :schedule, index: true
      t.string :name, limit: 80
      t.string :url_image, default: ""
      t.datetime :start_time

      t.timestamps null: false
    end
  end
end

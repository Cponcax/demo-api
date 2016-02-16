class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :show, index: true
      t.references :schedule, index: true
      t.datetime :start_time
      t.datetime :end_time
      t.string :streaming_url
      t.date :date

      t.timestamps null: false
    end
  end
end

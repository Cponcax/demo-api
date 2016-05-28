class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :show, index: true
      t.references :schedule, index: true
      t.time :start_time
      t.time :end_time
      t.string :streaming_url
  
      t.timestamps null: false
    end
  end
end

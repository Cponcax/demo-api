class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name
      t.integer :position
      t.string :streaming_url

      t.timestamps null: false
    end
  end
end

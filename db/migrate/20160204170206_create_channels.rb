class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name
      t.string :logo
      t.string :streaming_url
      t.integer :position

      t.timestamps null: false
    end
  end
end

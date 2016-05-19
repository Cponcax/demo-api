class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels do |t|
      t.string :name
      t.integer :position
      t.string :streaming_url
      t.string :logo_color

      t.timestamps null: false
    end
  end
end

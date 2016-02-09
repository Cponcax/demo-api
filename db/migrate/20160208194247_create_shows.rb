class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string :name
      t.string :logo
      t.string :cover

      t.timestamps null: false
    end
  end
end

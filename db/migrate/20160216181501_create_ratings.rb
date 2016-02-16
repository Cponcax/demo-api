class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end

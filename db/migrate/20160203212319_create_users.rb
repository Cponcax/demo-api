class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :code, null: false, limit: 8
      t.string :username, limit: 80, index: true
      t.string :first_name, limit: 80, index: true
      t.string :last_name, limit: 80, index: true
      t.string :gender
      t.text :bio
      t.date :birth_date

      t.timestamps null: false
    end
  end
end

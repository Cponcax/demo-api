class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name, limit: 100, null: false
      t.integer :code
      t.string :alpha2, limit: 2
      t.string :alpha3, limit: 3

      t.timestamps null: false
    end
  end
end

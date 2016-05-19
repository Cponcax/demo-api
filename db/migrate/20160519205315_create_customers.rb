class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.references :user, index: true
      t.string :email
      t.text :description

      t.timestamps null: false
    end
  end
end

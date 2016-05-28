class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.references :user, index: true
      t.string :email
      t.text :description
      t.string :original_transaction_id
      t.boolean :is_itunes, default: false

      t.timestamps null: false
    end
  end
end

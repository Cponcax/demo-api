class CreateBillingInformation < ActiveRecord::Migration
  def change
    create_table :billing_informations do |t|
      t.references :customer, index: true
      t.references :subscription, index: true
      t.string :receipt_number
      t.string :status

      t.timestamps null: false
    end
    add_index :billing_informations, :receipt_number, unique: true
  end
end

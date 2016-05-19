class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :customer, index: true
      t.references :subscription, index: true
      t.string :receipt_number
      t.string :status

      t.timestamps null: false
    end
    add_index :invoices, :receipt_number, unique: true
  end
end

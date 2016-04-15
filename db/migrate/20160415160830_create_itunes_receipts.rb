class CreateItunesReceipts < ActiveRecord::Migration
  def change
    create_table :itunes_receipts do |t|
      t.references :user, index: true, foreign_key: true
      t.text :receipt

      t.timestamps null: false
    end
  end
end

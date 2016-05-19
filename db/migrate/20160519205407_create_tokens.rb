class CreateTokens < ActiveRecord::Migration
  def change
    create_table :tokens do |t|
      t.references :customer, index: true
      t.string :access_token
      t.string :refresh_token
      t.string :token_type
      t.integer :expires_in

      t.timestamps null: false
    end
  end
end

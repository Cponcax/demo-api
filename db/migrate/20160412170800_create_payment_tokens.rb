class CreatePaymentTokens < ActiveRecord::Migration
  def change
    create_table :payment_tokens do |t|
      t.string :token_type
      t.string :expires_in
      t.string :refresh_token
      t.string :refresh_token
      t.integer :refresh_token

      t.timestamps null: false
    end
  end
end

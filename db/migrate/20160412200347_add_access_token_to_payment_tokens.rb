class AddAccessTokenToPaymentTokens < ActiveRecord::Migration
   def change
    add_column :payment_tokens, :access_token, :string
  end
end

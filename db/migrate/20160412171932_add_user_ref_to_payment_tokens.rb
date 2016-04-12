class AddUserRefToPaymentTokens < ActiveRecord::Migration
  def change
    add_reference :payment_tokens, :user, index: true, foreign_key: true
  end
end

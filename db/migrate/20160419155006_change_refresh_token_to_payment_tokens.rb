class ChangeRefreshTokenToPaymentTokens < ActiveRecord::Migration
  def change
  	change_column :payment_tokens, :refresh_token, :string
  end
end

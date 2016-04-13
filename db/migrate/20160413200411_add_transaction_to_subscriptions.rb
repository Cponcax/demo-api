class AddTransactionToSubscriptions < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :transaction_id, :string
  end
end

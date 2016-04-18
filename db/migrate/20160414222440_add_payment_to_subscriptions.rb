class AddPaymentToSubscriptions < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :payment, :boolean
  end
end

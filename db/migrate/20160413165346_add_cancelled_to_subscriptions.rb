class AddCancelledToSubscriptions < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :cancelled, :boolean
  end
end

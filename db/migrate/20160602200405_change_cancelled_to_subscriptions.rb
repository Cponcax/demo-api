class ChangeCancelledToSubscriptions < ActiveRecord::Migration
  def change
  	change_column :subscriptions, :cancelled, :boolean, :default => false
  end
end


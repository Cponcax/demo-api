class AddIdentifierToSubscriptions < ActiveRecord::Migration
  def change
  	add_column :subscriptions, :identifier, :string
  end
end

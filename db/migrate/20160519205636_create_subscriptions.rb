class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :billing_plan, index: true
      t.references :customer, index: true
      t.timestamp :canceled_at
      t.timestamp :current_period_start
      t.timestamp :current_period_end
      t.timestamp :ended_at
      t.timestamp :trial_start
      t.timestamp :trial_end
      t.string :status

      t.timestamps null: false
    end
  end
end

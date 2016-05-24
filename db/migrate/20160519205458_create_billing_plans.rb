class CreateBillingPlans < ActiveRecord::Migration
  def change
    create_table :billing_plans do |t|
      t.integer :amount
      t.string :currency
      t.string :interval
      t.integer :interval_count, default: 1
      t.string :name
      t.integer :trial_period_days

      t.timestamps null: false
    end
  end
end

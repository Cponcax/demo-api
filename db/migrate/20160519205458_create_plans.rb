class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.integer :ammount
      t.string :currency
      t.string :interval
      t.integer :interval_count
      t.string :name
      t.integer :trial_period_days

      t.timestamps null: false
    end
  end
end

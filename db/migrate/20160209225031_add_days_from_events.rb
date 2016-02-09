class AddDaysFromEvents < ActiveRecord::Migration
  def change
    add_column :events, :days, :integer
  end
end

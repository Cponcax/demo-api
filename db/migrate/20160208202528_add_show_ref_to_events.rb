class AddShowRefToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :show, index: true, foreign_key: true
  end
end

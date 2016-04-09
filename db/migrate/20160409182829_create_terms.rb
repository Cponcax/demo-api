class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string :term

      t.timestamps null: false
    end
  end
end

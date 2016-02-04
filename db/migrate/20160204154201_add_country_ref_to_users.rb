class AddCountryRefToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :country, index: true, foreign_key: true
  end
end

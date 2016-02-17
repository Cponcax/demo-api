class AddRatingToShows < ActiveRecord::Migration
  def change
  	 add_column :shows, :rating, :string
  end
end

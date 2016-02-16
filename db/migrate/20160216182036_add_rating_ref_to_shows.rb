class AddRatingRefToShows < ActiveRecord::Migration
  def change
    add_reference :shows, :rating, index: true, foreign_key: true
  end
end

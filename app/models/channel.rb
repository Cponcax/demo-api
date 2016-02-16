class Channel < ActiveRecord::Base
  has_many :schedules

  def give_shows
    shows = []
    self.schedules.each do |schedule|
      shows << schedule.shows
    end
    shows.flatten
  end

end

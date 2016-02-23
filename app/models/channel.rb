class Channel < ActiveRecord::Base
  has_many :schedules

  validates :name,  :position, :streaming_url, :logo_color, presence: true

  def give_shows
    shows = []
    self.schedules.each do |schedule|
      shows << schedule.shows
    end
    shows.flatten
  end

end

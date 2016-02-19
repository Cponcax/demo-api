class Channel < ActiveRecord::Base
  has_many :schedules

  validates :name, :logo, :streaming_url, :position, :logo_color, presence: true

  def give_shows
    shows = []
    self.schedules.each do |schedule|
      shows << schedule.shows
    end
    shows.flatten
  end

end

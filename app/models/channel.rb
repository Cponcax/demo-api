class Channel < ActiveRecord::Base
  has_many :schedules

  validates :name,  :position, :streaming_url, :logo_color, presence: true

  def give_shows
    shows = []
   
    self.schedules.each do |schedule|
      if schedule.date.wday == 3
      	shows << schedule.shows
      elsif schedule.date.wday == 2 
      	shows << schedule.shows
      end
    end
    shows.flatten
  end

end

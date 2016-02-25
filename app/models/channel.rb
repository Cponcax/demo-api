class Channel < ActiveRecord::Base
  has_many :schedules

  validates :name,  :position, :streaming_url, :logo_color, presence: true

  def monday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.wday == 1
      	shows << schedule.shows
      end
    end
    shows.flatten
  end

  def tuesday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.wday == 2
        shows << schedule.shows
      end
    end
    shows.flatten
  end

  def wednesday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.wday == 3
        shows << schedule.shows
      end
    end
    shows.flatten
  end

  def thursday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.wday == 4
        shows << schedule.shows
      end
    end
    shows.flatten
  end

  def friday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.wday == 5
        shows << schedule.shows
      end
    end
    shows.flatten
  end
  def saturday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.wday == 6
        shows << schedule.shows
      end
    end
    shows.flatten
  end

  def sunday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.wday == 7
        shows << schedule.shows
      end
    end
    shows.flatten
  end

end

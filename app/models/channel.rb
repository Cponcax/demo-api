class Channel < ActiveRecord::Base
  has_many :schedules

  validates :name,  :position, :streaming_url, :logo_color, presence: true

  def monday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.wday == 1 && schedule.date.strftime("%U")== Time.current.strftime("%U")
      	shows << schedule.shows
      end
    end
    shows.flatten
  end

  def tuesday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.wday == 2 && schedule.date.strftime("%U")== Time.current.strftime("%U")
        shows << schedule.shows.order('start_time ASC')
      end
    end
    shows.flatten
  end

  def wednesday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.wday == 3 && schedule.date.strftime("%U")== Time.current.strftime("%U")
        shows << schedule.shows.order('start_time ASC')
      end
    end
    shows.flatten
  end

  def thursday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.wday == 4 && schedule.date.strftime("%U")== Time.current.strftime("%U")
        shows << schedule.shows.order('start_time ASC')
      end
    end
    shows.flatten
  end

  def friday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.wday == 5 && schedule.date.strftime("%U")== Time.current.strftime("%U")
        shows << schedule.shows.order('start_time ASC')
      end
    end
    shows.flatten
  end
  def saturday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.wday == 6 && schedule.date.strftime("%U")== Time.current.strftime("%U")
        shows << schedule.shows.order('start_time ASC')
      end
    end
    shows.flatten
  end

  def sunday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.cwday == 7 && schedule.date.strftime("%W") == Time.current.strftime("%W")
        shows << schedule.shows.order('start_time ASC')
      end
    end
    shows.flatten
  end

end

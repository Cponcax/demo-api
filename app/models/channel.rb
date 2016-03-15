class Channel < ActiveRecord::Base
  include Imageable

  has_many :schedules

  has_attached_file :logo,
  styles: lambda { |a| a.instance.styles :logo },
  :default_url => lambda { |attachment| attachment.instance.default_url },
  url: '/system/:class/:attachment/:id/:access_token_:style.:extension'

  validates :name,  :position, :streaming_url, :logo_color, presence: true

  def monday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.wday == 1 && schedule.date.strftime("%U")== Time.current.strftime("%U")
      	shows << schedule.events.order('start_time ASC')
      end
    end
    shows.flatten
  end

  def tuesday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.wday == 2 && schedule.date.strftime("%U")== Time.current.strftime("%U")
        shows << schedule.events.order('start_time ASC')
      end
    end
    shows.flatten
  end

  def wednesday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.wday == 3 && schedule.date.strftime("%U")== Time.current.strftime("%U")
        shows << schedule.events.order('start_time ASC')
      end
    end
    shows.flatten
  end

  def thursday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.wday == 4 && schedule.date.strftime("%U")== Time.current.strftime("%U")
        shows << schedule.events.order('start_time ASC')
      end
    end
    shows.flatten
  end

  def friday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.wday == 5 && schedule.date.strftime("%U")== Time.current.strftime("%U")
        shows << schedule.events.order('start_time ASC')
      end
    end
    shows.flatten
  end
  def saturday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.wday == 6 && schedule.date.strftime("%U")== Time.current.strftime("%U")
        shows << schedule.events.order('start_time ASC')
      end
    end
    shows.flatten
  end

  def sunday
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.cwday == 7 && schedule.date.strftime("%W") == Time.current.strftime("%W")
        shows << schedule.events.order('start_time ASC')
      end
    end
    shows.flatten
  end

end

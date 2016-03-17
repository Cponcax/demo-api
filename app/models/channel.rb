class Channel < ActiveRecord::Base
  include Imageable

  has_many :schedules

  has_attached_file :logo,
  styles: lambda { |a| a.instance.styles :logo },
  :default_url => lambda { |attachment| attachment.instance.default_url },
  url: '/system/:class/:attachment/:id/:access_token_:style.:extension'

  validates :name,  :position, :streaming_url, :logo_color, presence: true

  def event_with_date(day, date_parse)
    shows = []

    self.schedules.each do |schedule|
      if schedule.date.wday == day.to_i && schedule.date.strftime("%U")== Time.current.strftime("%U")
        shows << schedule.events
      end
      events = schedule.events
      hour = date_parse.hour
      wday = schedule.date.wday
      uwday = date_parse.utc.wday

      filter_events = events.select { |e|
        uwday == wday && hour == e.start_time.hour
      }
      shows << filter_events
    end
    shows.flatten
  end


end

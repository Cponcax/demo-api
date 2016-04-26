class Event < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :show
  validates :schedule, :show, :presence => true

  validates :start_time, :end_time, :streaming_url ,presence: true


  def self.hour
    t = Time.utc(2001, 1, 1, Time.current.hour, Time.current.min, Time.current.sec)

    e = Schedule.get_day.events
    e.where("? BETWEEN start_time AND end_time", t )
  end

end

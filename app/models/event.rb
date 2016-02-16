class Event < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :show


  def self.day
    day = Date.today
    where("date = ?", day)
  end

  def self.hour
    t = Time.now
    where("? BETWEEN start_time AND end_time", t )
  end

end
class Schedule < ActiveRecord::Base
  has_many :events
  has_many :shows, through: :events
  belongs_to :channel
  validates :channel, :presence => true
  validates :channel_id, :date, :name, :turn, presence: true

 
  def self.get_day
    Time.zone = "Central America"

    date = Date.current.in_time_zone
    day_of_date = date.wday 
    # where("date =?", t) 
    
    select { |schedule|

      puts "DATE :: " + schedule.date.inspect

      puts "VERSION LOCAL::" + schedule.date.in_time_zone.inspect
      
      puts "T::" + date.inspect
      
      day_of_week = schedule.date.in_time_zone.wday 

      puts "SD::" + day_of_week.inspect
      
      puts "DAY:::" + day_of_week.inspect
      
      day_of_date == day_of_week
    }

  end

end
  
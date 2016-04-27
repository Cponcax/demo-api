class Schedule < ActiveRecord::Base
  has_many :events
  has_many :shows, through: :events
  belongs_to :channel
  validates :channel, :presence => true
  validates :channel_id, :date, :name, :turn, presence: true

 
 def self.get_day
  Time.zone = "Central America"
  t = Time.utc(Time.current.year, Time.current.month, Time.current.day, Time.current.hour, Time.current.min, Time.current.sec).in_time_zone
  puts "TIEMPO WITH TIME ZONE::" + t.inspect
  find_by("date =?", t)
 end

end

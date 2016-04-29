class Schedule < ActiveRecord::Base
  has_many :events
  has_many :shows, through: :events
  belongs_to :channel
  validates :channel, :presence => true
  validates :channel_id, :date, :name, :turn, presence: true

 
 
  def self.get_schedules_per_day
    Time.zone = "Central America"

    t = Date.current.in_time_zone

    puts "TIEMPO WITH TIME ZONE::" + t.inspect
    
    where("date =?", t) 
    
    # select {|s|
    #     puts "DATE :: " + s.date.inspect
    #     puts "VERSION LOCAL::" + s.date.in_time_zone.inspect
    #   s.date.in_time_zone == t 
    # }

  end

end
  
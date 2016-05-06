require 'tod/core_extensions'

class Event < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :show

  has_many :event_countries
  has_many :countries, through: :event_countries

  validates :schedule, :show, :presence => true

  validates :start_time, :end_time, :streaming_url ,presence: true



  def self.get_show_live(country)
    Time.zone = "Central America"
    
    t = Time.current.utc.to_time_of_day
    puts "TIME::" + t.inspect
  
    events = Schedule.get_days.map {|s| 
      s.events
    }.flatten
 
    events.select { |event| 

      st = event.start_time.to_time_of_day

      et = event.end_time.to_time_of_day

      Tod::Shift.new(st, et).include?(t) && event.countries.include?(country)
     }

  end

end

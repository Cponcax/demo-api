require 'tod/core_extensions'

class Event < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :show
  validates :schedule, :show, :presence => true

  validates :start_time, :end_time, :streaming_url ,presence: true



  def self.get_show_live
   # Time.zone = "Central America"
    
   #  t = Time.utc(2001, 1, 1, Time.current.hour, Time.current.min, Time.current.sec)
   #  e = Schedule.get_day.events

   #  t = Time.current.in_time_zone.strftime('%H:%M:%S')
   #  puts "TIME CURRENT: " + t.inspect

   #  events = Schedule.get_day.events

   #  #where("? BETWEEN start_time AND end_time", t )
   #  events.select { |event| 
   #    st = event.start_time.in_time_zone.strftime('%H:%M:%S')
   #    puts "START TIME: " + st.inspect
   #    et = event.end_time.in_time_zone.strftime('%H:%M:%S')
   #    puts "END TIME: " + et.inspect
        
   #      t >= st && t < et
   #  }
  puts "TIME CURRENT::" + Time.current.inspect

  puts"==============" 

  puts "UTC TIME CURRENT:: "+ Time.current.utc.inspect
  
  t = Time.current.utc.to_time_of_day

  events = Schedule.get_schedules_per_day rescue []

    show_live = events.map {|e| e.events} rescue []

  #puts "EVENTS" + events.inspect
   
  s = show_live.select { |event|  
    st = event.start_time.to_time_of_day rescue []
    et = event.end_time.to_time_of_day rescue []
   
    Tod::Shift.new(st, et).include?(t) rescue []
    
    }

  s.flatten
  
  end

end

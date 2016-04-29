require 'tod/core_extensions'

class Event < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :show
  validates :schedule, :show, :presence => true

  validates :start_time, :end_time, :streaming_url ,presence: true

  def self.get_show_live
   # Time.zone = "Central America"
 

  puts "TIME CURRENT::" + Time.current.inspect

  puts"==============" 

  puts "UTC TIME CURRENT:: "+ Time.current.utc.inspect
  
  t = Time.current.utc.to_time_of_day

  events = Schedule.get_day  rescue []

  show_live = events.map {|e| e.events[0]} rescue []

  puts "EVENTS" + events.inspect

  show_live.select{ |e| 
    begin
      st = e.start_time.to_time_of_day 
    puts "ST::" + st.inspect
    et = e.end_time.to_time_of_day 
    puts "ET::" + et.inspect
    Tod::Shift.new(st, et).include?(t)
    rescue Exception => e
      
    end
    
 
  } 
   
  end

end

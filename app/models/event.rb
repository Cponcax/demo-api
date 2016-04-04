class Event < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :show
  validates :schedule, :show, :presence => true

 validates :start_time, :end_time, :streaming_url ,presence: true


  def self.hour
    t = Time.current
    where("? BETWEEN start_time AND end_time", t )
  end

end

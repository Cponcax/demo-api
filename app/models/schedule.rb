class Schedule < ActiveRecord::Base
  has_many :events
  has_many :shows, through: :events
  belongs_to :channel
  validates :channel, :presence => true
  validates :channel_id, :date, :name, :turn, presence: true

 
  def self.get_day
    Time.zone = "Central America"

    t = Date.current.in_time_zone
    
    where("date =?", t) 

  end

end
  
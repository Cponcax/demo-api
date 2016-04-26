class Schedule < ActiveRecord::Base
  has_many :events
  has_many :shows, through: :events
  belongs_to :channel
  validates :channel, :presence => true
  validates :channel_id, :date, :name, :turn, presence: true

 
 def self.get_day
  t = Time.now
 #t = Time.utc(Time, 1, 1)
  find_by("date =?", t)
 end

end

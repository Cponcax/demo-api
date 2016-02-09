class Schedule < ActiveRecord::Base
belongs_to :channel
has_many :events


  def self.hour
    where("schedules.start = ?", Time.now)
  end
end

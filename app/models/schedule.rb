class Schedule < ActiveRecord::Base
has_many :events
has_many :shows, through: :events

  def self.hour
    where("schedules.start = ?", Time.now)
  end

end

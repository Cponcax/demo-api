class Show < ActiveRecord::Base
  has_many :events
  has_many :schedules, through: :events
  has_many :ratings

  def self.get_show
    Event.hour.day
  end

end

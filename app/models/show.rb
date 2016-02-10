class Show < ActiveRecord::Base
  has_many :events
  has_many :schedules,through: :events

def self.get_show
  Event.day
end

end

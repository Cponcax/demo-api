class Show < ActiveRecord::Base
  has_many :events
  has_many :schedules,through: :events 
end

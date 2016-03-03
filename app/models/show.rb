class Show < ActiveRecord::Base
  has_many :events
  has_many :schedules, through: :events

  validates :name, :rating, presence: true

  def self.get_show
    Event.hour #.day
  end


 # def self.day
 #    day = Date.today
 #    Schedule.where("date = ?", day)
 #  end

end

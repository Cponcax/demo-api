class Schedule < ActiveRecord::Base
belongs_to :channel
has_many :events
validates :start_time, :name, :days, presence: true
end

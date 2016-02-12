class Schedule < ActiveRecord::Base
has_many :events
belongs_to :channel
end

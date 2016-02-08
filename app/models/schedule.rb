class Schedule < ActiveRecord::Base
belongs_to :channel

validates :start_time, :name, :days, presence: true
end

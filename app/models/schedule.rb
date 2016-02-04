class Schedule < ActiveRecord::Base
belongs_to :channel

validates :start_date, :end_date, :name, :days, presence: true, uniqueness: true
end

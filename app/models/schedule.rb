class Schedule < ActiveRecord::Base
has_many :events
has_many :shows, through: :events
belongs_to :channel



end

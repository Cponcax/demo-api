class Schedule < ActiveRecord::Base
has_many :events
belongs_to :channel

def self.channel
Channel.where("SELECT name IS  NOT NULL")

end

end

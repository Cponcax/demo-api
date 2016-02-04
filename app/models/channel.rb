class Channel < ActiveRecord::Base
  has_many :schedules
  validates :name , :logo , :streaming_url , :position, presence: true, uniqueness: true
end

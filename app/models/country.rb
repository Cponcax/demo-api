class Country < ActiveRecord::Base
 
  has_many :event_countries 
  has_many :events, through: :event_countries
  
  validates :name, :alpha2, presence: true, uniqueness: true
end

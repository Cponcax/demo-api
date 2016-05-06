class Country < ActiveRecord::Base
  #has_many :users
  has_many :event_countries 
  has_many :events, through: :event_countries
  
  validates :name, :alpha2, :alpha3, presence: true, uniqueness: true
end

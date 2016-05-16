class EventCountry < ActiveRecord::Base
  belongs_to :event
  belongs_to :country
end

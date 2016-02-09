class Event < ActiveRecord::Base
belongs_to :schedule
belongs_to :show

end

class Country < ActiveRecord::Base
  has_many :users
  
  validates :name, :alpha2, :alpha3, presence: true, uniqueness: true
end

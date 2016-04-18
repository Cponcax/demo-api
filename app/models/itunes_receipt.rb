class ItunesReceipt < ActiveRecord::Base
  belongs_to :user
  
  validates :receipt, presence: true
end

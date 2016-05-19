class Customer < ActiveRecord::Base
  belongs_to  :user
  
  #for sdk paypal
  has_many    :tokens
  
  has_many    :subscriptions
  has_many    :invoices
end

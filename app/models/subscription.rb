require 'tod/core_extensions'

class Subscription < ActiveRecord::Base
  extend Enumerize

  belongs_to  :plan
  belongs_to  :customer

  # Initialize the payment object
  @@payment ||= {
    "intent" =>  "sale",
    "payer" =>  {
      "payment_method" =>  "paypal" 
    },
    "transactions" => [ 
      {
        "amount" => {
          "total" =>  "15.00",
          "currency" =>  "USD" 
        },
      "description" =>  "This is the payment transaction description." 
      } 
    ] 
  }

  enumerize :status, in: [:active, :inactive], default: :active, scope: :having_status, predicates: true

  def status_info
    t = DateTime.current.utc

    result = {}

    result[:cancelled] = current_period_start < t && t < current_period_end
    result[:status] = active?

    return result
  end

  def makePayment metadata_id
    # metadata_id from mobile sdk
    correlation_id = metadata_id
  end
end

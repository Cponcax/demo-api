class Subscription < ActiveRecord::Base
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

  def makePayment metadata_id
    # metadata_id from mobile sdk
    correlation_id = metadata_id
  end
end

class BillingInformation < ActiveRecord::Base
  belongs_to  :customer
  belongs_to  :subscription

  def getPaymentDetails
    puts "PAYMENT ID receipt_number IS: " + receipt_number.inspect
    # Fetch Payment
    payment = Payment.find(self.receipt_number)

    puts "PAYMENT:: " + payment.inspect

    return payment
  end
end

class BillingInformation < ActiveRecord::Base
  belongs_to  :customer
  belongs_to  :subscription

  def get_payment_details
    # Fetch Payment
	  Payment.find(self.receipt_number)
  end
end

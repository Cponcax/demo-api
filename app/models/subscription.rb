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

  validate :could_not_revoke_access, on: :cancel

  def info
    t = DateTime.current.utc

    if !(current_period_start < t && t < current_period_end)
      update status: :inactive
    end

    return {
      canceled: canceled?,
      status: active?
    }
  end

  def cancel
    transaction do
      valid?(:cancel) or raise ActiveRecord::RecordInvalid.new(self)
      update canceled_at: DateTime.current.utc
    end
  end

  def makePayment metadata_id
    # metadata_id from mobile sdk
    correlation_id = metadata_id
  end

    private

      def canceled?
        canceled_at.nil?
      end

      def could_not_revoke_access
        unless customer.tokens.destroy_all
          errors.add(:canceled_at, "an error trying to revoke access permissions has occurred.")
        end
      end
end

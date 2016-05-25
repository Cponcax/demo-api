require 'paypal-sdk-rest'

include PayPal::SDK::REST::DataTypes
include PayPal::SDK::Core::Logging
include PayPal::SDK::OpenIDConnect

class Subscription < ActiveRecord::Base
  extend Enumerize

  belongs_to  :billing_plan
  belongs_to  :customer

  has_many    :billing_information

  # Initialize the payment object
  PAYMENT ||= {
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

  before_create :set_access_time, :set_plan

  def info
    now = DateTime.current.utc
    ended_at = nil
    
    if !(current_period_start < now && now < current_period_end)
      if canceled?
        ended_at = current_period_end
      end
      update status: :inactive, ended_at: ended_at
    end

    return {
      cancelled: canceled?,
      status: active?
    }
  end

  def cancel
    transaction do
      valid?(:cancel) or raise ActiveRecord::RecordInvalid.new(self)
      update canceled_at: DateTime.current.utc
    end
  end

    private

      def set_plan
        plan = BillingPlan.get_basic_plan

        puts "PLAN IS:: " + plan.inspect

        self.billing_plan_id = plan.id
      end

      def canceled?
        !canceled_at.nil?
      end

      def set_access_time
        self.current_period_start = self.created_at
        self.current_period_end = self.created_at + 5.minutes
      end

      def could_not_revoke_access
        unless customer.tokens.destroy_all
          errors.add(:canceled_at, "an error trying to revoke access permissions has occurred.")
        end
      end
end

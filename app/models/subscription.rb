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

  enumerize :status, in: [:active, :inactive, :canceled], default: :active, scope: :having_status, predicates: true

  validate :could_not_revoke_access, on: :cancel

  before_create :set_start_time, :set_plan

  class << self
    def makePayment metadata_id, owner
      puts "OWNER: " + owner.inspect
      # metadata_id from mobile sdk
      correlation_id = metadata_id

      puts "CORRELATION ID:: " + correlation_id.inspect

      customer = owner.customers.first

      puts "CUSTOMER::: " + customer.inspect

      # get access_token, refresh_token from tokeninfo. refresh_token can be exchanged with access token. See https://github.com/paypal/PayPal-Ruby-SDK#openidconnect-samples
      token = customer.get_access_token

      puts "TOKEN::: " + token.inspect

      puts "ACCESS TOKEN IN PAYMENT IS: " + token.access_token.inspect
      puts "REFRESH TOKEN IN PAYMENT IS: " + token.refresh_token.inspect

      # Create tokeninfo by using refresh token
      tokeninfo = Tokeninfo.refresh(token.refresh_token)

      puts "NEW ACCESS TOKEN FROM REFRESH TOKEN IN PAYMENT IS: " + tokeninfo.inspect

      access_token = tokeninfo.access_token

      # Create Payments
      logger.info "Create Future Payment"
      future_payment = FuturePayment.new(@@payment.merge( :token => access_token ))

      puts "FUTURE PAYMENT NEW IS: " + future_payment.inspect
      puts "FUTURE PAYMENT NEW ERROR IS: " + future_payment.error.inspect
      
      success = future_payment.create(correlation_id)

      if success
        subscription = customer.subscriptions.find_or_create_by status: :active

        puts "subscription IS:: " + subscription.inspect
        
        if subscription


          logger.info "future payment successfully created"
          subscription.billing_information.create!(receipt_number: future_payment.id, customer_id: customer.id)
        end
      end

      return future_payment
    end
  end

  def info
    now = DateTime.current.utc
    ended_at = nil
    
    if !(current_period_start < now && now < current_period_start + 15.minutes)
      if canceled?
        ended_at = now
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
      update canceled_at: DateTime.current.utc, status: :canceled
    end
  end

    private

      def set_plan
        plan = BillingPlan.get_basic_plan

        puts "PLAN IS:: " + plan.inspect

        self.billing_plan_id = plan.id
      end

      def set_start_time
        self.current_period_start = self.created_at
      end

      def could_not_revoke_access
        unless customer.tokens.destroy_all
          errors.add(:canceled_at, "an error trying to revoke access permissions has occurred.")
        end
      end
end

require 'paypal-sdk-rest'

include PayPal::SDK::REST::DataTypes
include PayPal::SDK::Core::Logging
include PayPal::SDK::OpenIDConnect

class Customer < ActiveRecord::Base
  belongs_to  :user
  
  #for sdk paypal
  has_one    :token

  has_many    :subscriptions
  has_many    :billing_information


  def exch_token authorization_code
    # authorization code from mobile sdk

    transaction do
      # exchange authorization code with refresh/access token
      logger.info "Exchange authorization code with refresh/access token"
      info  = ::FuturePayment.exch_token(authorization_code)

      puts "Token info: " + info.inspect

      # get access_token, refresh_token from tokeninfo. refresh_token can be exchanged with access token. See https://github.com/paypal/PayPal-Ruby-SDK#openidconnect-samples
      logger.info "Successfully retrieved access_token=#{info.access_token} refresh_token=#{info.refresh_token}"

      create_token!(access_token: info.access_token, refresh_token: info.refresh_token, token_type: info.token_type, expires_in: info.expires_in)
    end
  end

  def make_payment metadata_id
    # get access_token, refresh_token from tokeninfo. refresh_token can be exchanged with access token. See https://github.com/paypal/PayPal-Ruby-SDK#openidconnect-samples
    # Create tokeninfo by using refresh token
    tokeninfo = Tokeninfo.refresh(token.refresh_token)

    # Create Future Payment
    future_payment = FuturePayment.new(Subscription::PAYMENT.merge( :token => tokeninfo.access_token ))

    if future_payment.create(metadata_id) # metadata_id from mobile sdk
      renew_subscription future_payment.id
    end

    return future_payment
  end

  def renew_subscription receipt_number
    s = subscriptions.find_or_initialize_by ended_at: nil
        
    unless s.new_record?
      s.current_period_end = s.current_period_end + 30.days
    end
    s.status = :active 
        
    if s.save!
      s.billing_information.create!(receipt_number: receipt_number, customer_id: self.id)
    end
  end

  def get_current_subscription
    subscriptions.find_by(status: :active)
  end
end
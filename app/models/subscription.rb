require 'paypal-sdk-rest'
include PayPal::SDK::REST::DataTypes
include PayPal::SDK::Core::Logging

class Subscription < ActiveRecord::Base
  class << self
    def status
​
    end

    def getAccessToken(authorization_code)
      # authorization code from mobile sdk
      #authorization_code = ''
      # exchange authorization code with refresh/access token
      logger.info "Exchange authorization code with refresh/access token"
      tokeninfo  = ::FuturePayment.exch_token(authorization_code)
      # get access_token, refresh_token from tokeninfo. refresh_token can be exchanged with access token. See https://github.com/paypal/PayPal-Ruby-SDK#openidconnect-samples
      access_token = tokeninfo.access_token
      logger.info "Successfully retrieved access_token=#{access_token} refresh_token=#{tokeninfo.refresh_token}"

      # more attribute available in tokeninfo
      logger.info tokeninfo.to_hash
​
      #save access token in database.
    end

    def makePayment(user, metadata_id = '')
      correlation_id = metadata_id
      # Initialize the payment object
      payment = {
        "intent" =>  "authorize",
        "payer" =>  {
          "payment_method" =>  "paypal" },
        "transactions" =>  [ {
          "amount" =>  {
            "total" =>  "1.00",
            "currency" =>  "USD" },
          "description" =>  "This is the payment transaction description." } ] }
​
      #get access token from database
      access_token = user.getTokenForPayment
​
      #verificar el estado del token, es v'alido?
​
      # Create Payments
      logger.info "Create Future Payment"
      future_payment = FuturePayment.new(payment.merge( :token => access_token ))
      success = future_payment.create(correlation_id)
​
      # check response for status
        if success
          logger.info "future payment successfully created"
          #create subscription
        else
          logger.info "future payment creation failed"
        end
    end

    def remove
      self.autorenewal = false
      access_token = user.getTokenForPayment
      access_token.destroy
    end

  end
end

require 'paypal-sdk-rest'
include PayPal::SDK::REST::DataTypes
include PayPal::SDK::Core::Logging

class Subscription < ActiveRecord::Base
  belongs_to :user
  class << self 
    
    def status(user)
      t = Time.current
      user.subscriptions.where("end_date < ?", t ).update_all(status: false)
      user.subscriptions.where("? BETWEEN start_date AND end_date", t )
    end

    def getAccessToken(user, authorization_code)
      # authorization code from mobile sdk
      # exchange authorization code with refresh/access token
  
      logger.info "Exchange authorization code with refresh/access token"
      tokeninfo  = ::FuturePayment.exch_token(authorization_code)
      # get access_token, refresh_token from tokeninfo. refresh_token can be exchanged with access token. See https://github.com/paypal/PayPal-Ruby-SDK#openidconnect-samples
      access_token = tokeninfo.access_token
      logger.info "Successfully retrieved access_token=#{access_token} refresh_token=#{tokeninfo.refresh_token}"

      # more attribute available in tokeninfo
      logger.info "INFORMATION TOKEN HASH"

      payment_token =  user.payment_tokens.create!("token_type" => tokeninfo.token_type, 
      "expires_in" => tokeninfo.expires_in, "expires_in" => tokeninfo.expires_in,
      "refresh_token" => tokeninfo.refresh_token, "access_token" => access_token )
     
    end

    def makePayment(user, metadata_id = '')
      correlation_id = metadata_id
      # Initialize the payment object
      payment = {
        "intent" =>  "sale",
        "payer" =>  {
          "payment_method" =>  "paypal" },
        "transactions" =>  [ {
          "amount" =>  {
            "total" =>  "15.00",
            "currency" =>  "USD" },
          "description" =>  "This is the payment transaction description." } ] }

      #get access token from database
      access_token =  user.payment_tokens.last.access_token

      #CREATE susbscription 
      Subscription.create!("user_id" => user.payment_tokens.last.user_id, "cancelled"=> false,
        "start_date" => user.payment_tokens.last.created_at, "end_date" => user.payment_tokens.last.created_at + 30.days, "status" => true)

      # Create Payments
      if user.subscriptions.last.cancelled == false  && user.subscriptions.last.end_date < Time.current 

        logger.info "Create Future Payment"
        future_payment = FuturePayment.new(payment.merge( :token => access_token ))
        success = future_payment.create(correlation_id)

        # check response for status
        if success
          logger.info "future payment successfully created"
          user.subscriptions.last.update!("payment" => true)
        else
          logger.info "future payment creation failed"
        end
       
      else
        logger.info "You already have a subscription"
        user.subscriptions.last.destroy
      end
    end


    def firstMakePayment(user, metadata_id = '')
      correlation_id = metadata_id

      # Initialize the payment object
      payment = {
        "intent" =>  "sale",
        "payer" =>  {
          "payment_method" =>  "paypal" },
        "transactions" =>  [ {
          "amount" =>  {
            "total" =>  "15.00",
            "currency" =>  "USD" },
          "description" =>  "This is the payment transaction description." } ] }

      #get access token from database
      access_token =  user.payment_tokens.last.access_token

      #CREATE susbscription 
      Subscription.create!("user_id" => user.payment_tokens.last.user_id, "cancelled"=> false,
        "start_date" => user.payment_tokens.last.created_at, "end_date" => user.payment_tokens.last.created_at + 30.days, "status" => true)

      # Create Payments
      logger.info "Create Future Payment"
      future_payment = FuturePayment.new(payment.merge( :token => access_token ))
      success = future_payment.create(correlation_id)

      # check response for status
      if success
        logger.info "future payment successfully created"
        
      else
        logger.info "future payment creation failed"
      end
    end

    def cancel(user)
      if user.subscriptions.last.cancelled == true
        access_token = user.payment_tokens
        access_token.destroy_all
      else
        user.subscriptions.last.update(cancelled: true)
        access_token = user.payment_tokens
        access_token.destroy_all
      end
    end

    #for IOS devise
    def PaymentIos(user ,start_date,end_date, transaction_id, identifier, cancelled)
      payment = user.subscriptions.create!("start_date" => start_date, "end_date"=> end_date,
        "transaction_id" => transaction_id, "identifier" => identifier, "cancelled"=> cancelled)
    end

  end
end

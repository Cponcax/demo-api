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
    logger.info "Create Future Payment"
    future_payment = FuturePayment.new(Subscription::PAYMENT.merge( :token => tokeninfo.access_token ))

    begin
      puts "FUTURE PAYMENT IS::: " + future_payment.inspect 
      puts "METADATA ID IS::: " + metadata_id.inspect 
      
      # Do not cache or store the metadata ID. PayPal provides no loss protection if a metadata ID was not correctly specified.      
      success = future_payment.create(metadata_id)

      puts "SUCCESS::: " + success.inspect

      # check response for status
      if success
        transaction do
          s = subscriptions.find_or_initialize_by ended_at: nil

          puts "SUBSCRIPTION VALUE IS:: " + s.inspect
          
          unless s.new_record?
            puts "SUBSCRIPTION IS NOT A NEW RECORD"
            s.current_period_end = s.current_period_end + 30.days
          else
            puts "SUBSCRIPTION IS A NEW RECORD"
          end
          s.status = :active 
              
          if s.save!
            puts "SUBSCRIPTION IS SAVE"
            s.billing_information.create!(receipt_number: future_payment.id, customer_id: self.id)
            authorization_id = future_payment.transactions[0].related_resources[0].authorization.id

            puts "AUTHORIZATION ID::: " + authorization_id.inspect

            logger.info "Capture Future Payment"
            @authorization = Authorization.find(authorization_id)
            puts "AUTHORIZATION OBJECT IS:: " + @authorization.inspect
            @capture = @authorization.capture(Subscription::CAPTURE)

            puts "CAPTURE OBJECT IS::: " + @capture.inspect
            
            if @capture.success? # Return true or false
              logger.info "XXX Capture[#{@capture.id}]"
            else
              logger.error @capture.error.inspect
              # void an authorized payment
              if @authorization.void # Return true or false
                logger.info "Void an Authorization[#{@authorization.id}]"
              else
                 puts "VOID ERROR IS::: "
                logger.error @authorization.error.inspect
              end
              raise StandardError, @capture.error
            end
          end

        end
      else
        puts "ERROR FUTURE PAYMENT IS::: "
        raise StandardError, "FAIL CREATING FUTURE PAYMENT, PROBABLY metadata_id"
      end
    rescue StandardError => error
      puts "ERROR IS::: " + error.message

      # void authorization
      future_payment.error = error.message
    end

    return future_payment
  end

  def get_current_subscription
    subscriptions.find_by(status: :active)
  end
end
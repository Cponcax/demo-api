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
      # Do not cache or store the metadata ID. PayPal provides no loss protection if a metadata ID was not correctly specified.      
      success = future_payment.create(metadata_id)

      # check response for status
      if success
        transaction do
          s = subscriptions.find_or_initialize_by ended_at: nil

          unless s.new_record?
            s.current_period_end = s.current_period_end + 30.minutes
          end
          s.status = :active 
              
          if s.save!
            logger.info "create billing information"
            s.billing_information.create!(receipt_number: future_payment.id, customer_id: self.id)
            authorization_id = future_payment.transactions[0].related_resources[0].authorization.id

            logger.info "find authorization object"
            @authorization = Authorization.find(authorization_id)

            logger.info "Make capture"
            @capture = @authorization.capture(Subscription::CAPTURE)
            
            if @capture.success? # Return true or false
              logger.info "Capture[#{@capture.id}]"
            else
              logger.error @capture.error.inspect
              # void an authorized payment
              if @authorization.void # Return true or false
                logger.info "Void an Authorization[#{@authorization.id}]"
              end
              raise StandardError, @capture.error
            end
          end

        end
      else
        raise StandardError
      end
    rescue StandardError => err
      logger.error "Error is: " + err.message
      future_payment.error = err.message
    end

    return future_payment
  end

  def get_current_subscription
    subscriptions.find_by(status: :active)
  end
end
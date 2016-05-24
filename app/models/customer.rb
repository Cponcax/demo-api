require 'paypal-sdk-rest'

include PayPal::SDK::REST::DataTypes
include PayPal::SDK::Core::Logging
include PayPal::SDK::OpenIDConnect

class Customer < ActiveRecord::Base
  belongs_to  :user
  
  #for sdk paypal
  has_many    :tokens

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

      tokens.create!(access_token: info.access_token, refresh_token: info.refresh_token, token_type: info.token_type, expires_in: info.expires_in)
    end
  end

  def get_access_token
    tokens.select { |token| !token.expired? }[0]
  end

  def get_current_subscription
    subscriptions.find_by(status: :active)
  end
end
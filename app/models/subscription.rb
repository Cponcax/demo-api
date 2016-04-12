require 'paypal-sdk-rest'
include PayPal::SDK::REST::DataTypes
include PayPal::SDK::Core::Logging

class Subscription < ActiveRecord::Base
  class << self

    def getAccessToken(authorization_code)
      # authorization code from mobile sdk
      #authorization_code = ''
      # exchange authorization code with refresh/access token
      logger.info "Exchange authorization code with refresh/access token"
      tokeninfo  = ::FuturePayment.exch_token(authorization_code)
​
      # get access_token, refresh_token from tokeninfo. refresh_token can be exchanged with access token. See https://github.com/paypal/PayPal-Ruby-SDK#openidconnect-samples
      access_token = tokeninfo.access_token
      logger.info "Successfully retrieved access_token=#{access_token} refresh_token=#{tokeninfo.refresh_token}"

      # more attribute available in tokeninfo
      logger.info tokeninfo.to_hash
​
      #save access token in database.
    end

  end
end

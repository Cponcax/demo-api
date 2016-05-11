class Oauth::TokensController < Doorkeeper::TokensController
  include AbstractController::Callbacks

 #after_action :identify_origin, only: [:create]

  def create

    response = authorize_response
    body = response.body

    if response.status == :ok
     # User the resource_owner_id from token to identify the user
     user = User.find(response.token.resource_owner_id) rescue nil

     unless user.nil?
       body[:user] = ({ first_name: user.first_name, last_name: user.last_name,email: user.email}).as_json
     end
    end

    self.headers.merge! response.headers
    self.response_body = body.to_json
    self.status        = response.status

    rescue Doorkeeper::Errors::DoorkeeperError => e
    handle_token_exception e
   
  end

    # OAuth 2.0 Token Revocation - http://tools.ietf.org/html/rfc7009
    def revoke
      # The authorization server first validates the client credentials
      if doorkeeper_token && doorkeeper_token.accessible?
        # Doorkeeper does not use the token_type_hint logic described in the RFC 7009
        # due to the refresh token implementation that is a field in the access token model.
        revoke_token(request.POST['token']) if request.POST['token']

        render json: {}, status: 200
      else
        render json: { error: 'You shall not pass' }, status: 401
      end
      # The authorization server responds with HTTP status code 200 if the
      # token has been revoked successfully or if the client submitted an invalid token
      #render json: {}, status: 200
    end

  private

    def identify_origin
      if response.status.eql? 200
        current_user = User.find(authorize_response.token.resource_owner_id)

        # request.remote_ip
        # example: '147.243.3.83'
        Countries::IdentifyCountry.new(current_user, "147.243.3.83").call()
      end
    end

end

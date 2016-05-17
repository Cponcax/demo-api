class Oauth::TokensController < Doorkeeper::TokensController
  include AbstractController::Callbacks

  def create
    response = authorize_response
    body = response.body

    self.headers.merge! response.headers
    self.response_body = body.to_json
    self.status        = response.status

    rescue Doorkeeper::Errors::DoorkeeperError => e
    handle_token_exception e
  end

  # OAuth 2.0 Token Revocation - http://tools.ietf.org/html/rfc7009
  def revoke
    # The authorization server first validates the client credentials
    if doorkeeper_token #&& doorkeeper_token.accessible?
      # Doorkeeper does not use the token_type_hint logic described in the RFC 7009
      # due to the refresh token implementation that is a field in the access token model.
      revoke_token(request.POST['token']) if request.POST['token']

      render json: {}, status: 200
    else
      error = Doorkeeper::OAuth::ErrorResponse.new(name: :access_denied)
      response.headers.merge!(error.headers)

      render json: error.body, status: error.status
    end
    # The authorization server responds with HTTP status code 200 if the
    # token has been revoked successfully or if the client submitted an invalid token
    #render json: {}, status: 200
  end
  
end

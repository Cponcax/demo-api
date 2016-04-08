module TokensDoc
  extend ActiveSupport::Concern
  extend Apipie::DSL::Concern

  api :POST, "/oauth/token", "Create an access token"
  error :code => 401, :desc => "Unauthorized", :meta => {:message => "It should contain a header 'Authorization' and a 'Bearer' token."}
  param :grant_type, ['password','refresh_token'], :desc => "Authorization grant type", :required => false
  param :email, String, :desc => "User's email", :required => true
  param :password, String, :desc => "User's password (minimum 8 characters)", :required => true
  param :scope, String, :desc => "Authorization scopes", :required => true
  formats ['json']
  example '
  {
    "grant_type":"password",
    "email":"elsa20@gmail.com",
    "password":"welcome123",
    "scope":"write"
  }

  {
    "grant_type":"refresh_token",
    "refresh_token":"ac71b2be0ba7cfe970f41434fd8ebd356a2cb6035c8bdfc064f395e2af23fd4"
  }


  return token
  {
    "access_token": "10cb16bd3201e5a83ff26714dd2d351fe417684dd232c70acb5d6a5691f095a9",
    "token_type": "bearer",
    "expires_in": 7200,
    "refresh_token": "912420b5eb4502ba6c763dc6ec27b3aec3ee418bd8a24597229f6e50779d9dd6",
    "scope": "write",
    "created_at": 1460148411,
    "user":{
    "first_name": "de Arco",
    "last_name": "Ponce",
    "email": "prueba13@gmail.com"
    }
  }
  '


  def token
    # ...
  end

  api :POST, "/oauth/revoke", "Revoke a token"
  error :code => 401, :desc => "Unauthorized", :meta => {:message => "It should contain a header 'Authorization' and a 'Bearer' token."}
  param :token, String, :desc => "Token that will be revoked.", :required => true
  formats ['json']
  example '
  {
    "token":"66131978eb1ead37d5e0e3885baed30a93e728853dffa225ae1aec5bc3c04ca"
  }'
  def revoke
    # ...
  end
end

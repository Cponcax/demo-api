class AccessTokenSerializer < ActiveModel::Serializer
  attributes :access_token, :token_type, :expires_in, :refresh_token, :scope, :created_at
 
  def access_token
    object.token
  end

  def token_type
    'bearer'
  end

  def scope
    'write'
  end

  def created_at
    object.created_at.to_i
  end
end

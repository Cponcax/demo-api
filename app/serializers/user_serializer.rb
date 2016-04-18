class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :first_name, :last_name, :email, :gender, :birth_date, :bio

	has_one :access_token, serializer: AccessTokenSerializer

	 def access_token
    object.token
  end
  
end

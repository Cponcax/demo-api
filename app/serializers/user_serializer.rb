class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :first_name, :last_name, :email, :gender, :birth_date, :bio
  has_many :access_tokens
  has_many :subscriptions

end

class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :first_name, :last_name, :email, :gender, :birth_date, :bio, :token
  def token
    # puts "self: " + self.inspect
    # puts "self object: " + self.object.inspect
    #{self.object.access_tokens}
  

  end

end

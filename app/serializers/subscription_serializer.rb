class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :cancelled, :status

  def user_mail
  	object.user_id
  end
end

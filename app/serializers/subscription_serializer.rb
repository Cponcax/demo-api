class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :start_date, :end_date, :created_at, :user_id, :cancelled, :payment

  def user_mail
  	object.user_id
  end
end

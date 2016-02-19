class ReminderSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :channel_id, :schedule_id, :name, :url_image, :start_time
end

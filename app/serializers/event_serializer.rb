class EventSerializer < ActiveModel::Serializer
  attributes :id, :streaming_url, :date
end

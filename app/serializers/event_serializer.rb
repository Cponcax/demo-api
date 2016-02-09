class EventSerializer < ActiveModel::Serializer
  attributes :id, :streaming_url, :days
end

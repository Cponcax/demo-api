class EventSerializer < ActiveModel::Serializer
  attributes :channel_id,:schedule, :name, :start_time, :end_time, :streaming_url, :date

  def name
    object.show.name
  end

  def channel_id
    object.schedule.channel_id
  end

  
end

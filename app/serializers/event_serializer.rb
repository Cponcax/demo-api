class EventSerializer < ActiveModel::Serializer
  attributes :channel_id,:schedule, :name, :cover ,:start_time, :end_time, :streaming_url

  def name
    object.show.name
  end

  def cover
    object.show.cover
  end

  def channel_id
    object.schedule.channel_id
  end

  def schedule
    object.schedule.name
  end

end

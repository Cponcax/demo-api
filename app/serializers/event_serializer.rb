class EventSerializer < ActiveModel::Serializer
  attributes :channel_id, :show_id , :name, :cover ,:logo ,:rating, :datetime, :streaming_url

  def name
    object.show.name
  end

  def cover
    object.show.cover
  end

  def logo
    object.show.logo
  end

  def channel_id
    object.schedule.channel_id
  end

  def schedule
    object.schedule.name
  end


  def datetime

    d = object.schedule.date
    t = object.start_time
    dt = DateTime.new(d.year, d.month , d.day, t.hour, t.min, t.sec, t.zone)
  end

 def rating
   object.show.rating
 end
 def show_id
   object.show.id
 end

end

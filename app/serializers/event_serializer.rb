class EventSerializer < ActiveModel::Serializer
  attributes  :id,  :channel_id, :channel_name ,:name, :cover ,
              :logo,  :logo_channel ,:logo_color, :rating, :datetime, 
              :streaming_url, :streaming_wifi, :streaming_3g


  def channel_name
    object.schedule.channel.name
  end

  def logo_color
    object.schedule.channel.logo_color
  end


   def logo_channel
    object.schedule.channel.logo
   end

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

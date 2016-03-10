class ShowSerializer < ActiveModel::Serializer
  attributes :id, :name, :rating, :logo, :datetime, :cover,  :turn



  def turn
    object.schedules.first.turn
  end

  def datetime

    d = object.schedules.first.date
    t = object.events.first.start_time
    dt = DateTime.new(d.year, d.month , d.day, t.hour, t.min, t.sec)
  end

end

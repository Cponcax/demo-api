class ShowSerializer < ActiveModel::Serializer
  attributes :id, :name, :rating, :logo, :date, :cover, :start_time, :turn

  def start_time
    object.events.first.start_time
  end

  def turn
    object.schedules.first.turn
  end

  def logo
    object.url
  end

  def date
    object.schedules.last.date
  end

end

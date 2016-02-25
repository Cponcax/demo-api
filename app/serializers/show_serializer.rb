class ShowSerializer < ActiveModel::Serializer
  attributes :id, :name, :rating, :logo, :cover, :start_time, :turn

  def start_time
    object.events.first.start_time
  end

  def turn
    object.schedules.first.turn
  end

#fields  Serializer only example
  def  logo
    object = "https://i.ytimg.com/vi/Q0NzALRJifI/maxresdefault.jpg"
  end

  def  cover
    object = "https://i.ytimg.com/vi/Q0NzALRJifI/maxresdefault.jpg"
  end

end

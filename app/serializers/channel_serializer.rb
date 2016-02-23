class ChannelSerializer < ActiveModel::Serializer
  attributes :id,:name, :start_time, :logo, :streaming_url, :position, :logo_color, :created_at,:updated_at


#fields  Serializer only example
  def  logo
    object = "https://i.ytimg.com/vi/Q0NzALRJifI/maxresdefault.jpg"
  end

end

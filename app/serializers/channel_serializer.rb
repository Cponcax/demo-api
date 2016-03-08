class ChannelSerializer < ActiveModel::Serializer
  attributes :id,:name, :logo, :streaming_url, :position, :logo_color, :created_at,:updated_at


#fields  Serializer only example

  def logo
    object.logo.path

  end
end

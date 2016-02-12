class ChannelSerializer < ActiveModel::Serializer
  attributes :id,:name, :logo, :streaming_url, :position

  # def show_name
  #   object.show.name
  # end
end

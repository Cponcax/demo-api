class ChannelSerializer < ActiveModel::Serializer
  attributes :id,:name, :logo, :streaming_url, :position, :logo_color, :created_at,:updated_at


end

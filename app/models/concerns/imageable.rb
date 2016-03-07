module Imageable
  extend ActiveSupport::Concern

  included do
  end

  OPTIONS = {
    channel: {
      logo: {
        thumb: "60x44",
        normal: '87x65',
        medium: '174x130',
        large: '261x195'
      }
    },
    show: {
      logo: {
        thumb: "60x44",
        normal: '116x116',
        medium: '232x232',
        large: '348x348'
      },
      cover: {
        thumb: "60x44",
        normal: '320x262',
        medium: '640x524',
        large: '960x786'
      }
    }
  }

  def default_url
    '/images/:style/missing.png'
  end

  def url
    '/system/:class/:attachment/:id/:access_token_:style.:extension'
  end

  def options
    OPTIONS[scope]
  end

  def styles asset
    {
      thumb: {
        geometry: "60x44>",
        convert_options: "-quality 75 -strip"
      },
      normal: {
        geometry: options[asset][:normal] + '>',
        convert_options: '-quality 70'
      },
      medium: {
        geometry: options[asset][:medium] + '>',
        convert_options: '-quality 70'
      },
      large: {
        geometry: options[asset][:large] + '>',
        convert_options: '-quality 70'
      },
      cropped_normal: {
        geometry: options[asset][:normal] + '^',
        convert_options: "+repage -gravity north -crop #{options[asset][:normal]}+0+0 -quality 70 -strip"
      },
      cropped_medium: {
        geometry: options[asset][:medium] + '^',
        convert_options: "+repage -gravity north -crop #{options[asset][:medium]}+0+0 -quality 70 -strip"
      },
      cropped_large: {
        geometry: options[asset][:large] + '^',
        convert_options: "+repage -gravity north -crop #{options[asset][:large]}+0+0 -quality 70 -strip"
      }
    }
  end

  private

    def scope
      self.class.name.downcase.to_sym
    end

    # simple random salt
    def random_salt(len = 20)
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      salt = ""
      1.upto(len) { |i| salt << chars[rand(chars.size-1)] }
      return salt
    end

    # SHA1 from random salt and time
    def generate_access_token
      self.access_token = Digest::SHA1.hexdigest("#{random_salt}#{Time.now.to_i}")
    end

    # interpolate in paperclip
    Paperclip.interpolates :access_token  do |attachment, style|
      attachment.instance.access_token
    end

end

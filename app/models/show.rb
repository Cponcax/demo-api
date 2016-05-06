class Show < ActiveRecord::Base
  include Imageable

  has_many :events
  has_many :schedules, through: :events

  validates :name, :rating, presence: true



  has_attached_file :logo,
    styles: lambda { |a| a.instance.styles :logo },
    :default_url => lambda { |attachment| attachment.instance.default_url },
    url: '/system/:class/:attachment/:id/:basename_:style.:extension'

  has_attached_file :cover,
    styles: lambda { |a| a.instance.styles :cover },
    :default_url => lambda { |attachment| attachment.instance.default_url },
    url: '/system/:class/:attachment/:id/:basename_:style.:extension'

  def self.show_live(country)
    Event.get_show_live
  end



end

class Reminder < ActiveRecord::Base
  belongs_to :user
  validates :user, :presence => true
  validates :name, :url_image, presence: true

  MAX_VALUE = 2**7 - 1
  DAY_NAMES = %w(sunday monday tuesday wednesday thursday friday saturday).map(&:to_sym).freeze
  DAY_BITS  = Hash[ DAY_NAMES.zip(Array.new(7) { |i| 2**i }) ].freeze

  def self.weekdays bitmask
    #days = %w(Mon Tue Wed Thu Fri Sat Sun)
    DAY_NAMES.map.with_index { |day, i| day if bitmask & 2**i > 0 }.compact
  end

  def self.coerce_to_bit(wday)
    case wday
    when Symbol
      DAY_BITS[wday]
    when Fixnum, /\A[0-6]\Z/
      wday = wday.to_i
      (0..6).include?(wday) ? 2**wday : nil
    when Date, Time
      2**wday.wday
    when /\A(sun|mon|tues|wednes|thurs|fri|satur)day\Z/i
      DAY_BITS[wday.downcase.to_sym]
    end
  end
end

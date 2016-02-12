class Channel < ActiveRecord::Base
  has_many :schedules

  def self.get_arel_show
  #   shows = Arel::Table.new(:shows)
  #   channels = Arel::Table.new(:channels)
  # channel_show =  channels.join(shows).on(channels[:id].eq(shows[:channel_id]))
  # channel_show.to_sql

  #users.join(photos).on(users[:id].eq(photos[:user_id]))
# => SELECT * FROM users INNER JOIN photos ON users.id = photos.user_id


    #  SELECT * FROM events INNER JOIN shows ON events.id = shows.events.id;
  end

  def self.get_show
      get_arel_show
   end

end

class Channel < ActiveRecord::Base
  has_many :schedules

  def self.get_arel_show
    schedules = Arel::Table.new(:schedules)
    channels = Arel::Table.new(:channels)
    events = Arel::Table.new(:events)
    shows = Arel::Table.new(:shows)

    channel_show =  shows.join(events).on(shows[:id].eq(events[:show_id]))
    .where(schedules[:channel_id].eq(1))
    .project(Arel.sql('*'))
    #.where(shows[:show_id].eq(2)).project(Arel.sql('*'))
    channel_show.to_sql

    #users.where(users[:age].eq(10)).project(Arel.sql('*'))
    # SELECT "shows".* FROM "shows" INNER JOIN "events" ON "shows"."id" = "events"."show_id"
    # WHERE "events"."schedule_id" = $1  [["schedule_id", 3]]

    #users.join(photos).on(users[:id].eq(photos[:user_id]))
    # => SELECT * FROM users INNER JOIN photos ON users.id = photos.user_id
    #  SELECT * FROM channels INNER JOIN shows ON shows.id = schedules.events.id;

    #SELECT * FROM channels INNER JOIN schedules  ON channel_id = channel_id;
  end

  # def self.show
  #   #self.find_by_sql("SELECT * FROM shows INNER JOIN events  ON shows.id = events.show_id;")
  #   self.find_by_sql(get_arel_show)
  # end


  def get_name

  end


end

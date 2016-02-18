# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

channel = Channel.create([{name: 'canal cuatro', logo:'logo canalcuatro', streaming_url: 'streaming_url_canalcuatro', position: '4'}])

schedule = Schedule.create([{channel_id: 1 , date:'Thu, 18 Feb 2016 16:00:45 UTC +00:00', name: 'Programacion canal dos', turn: 'manana'}])

show = Show.create([{name: 'Viva la manana' , logo:'logo viva la manana', cover: 'Cover viva la manana', rating: 'Para todo publico'}])

event = Event.create([{show_id: 1, schedule_id: 1, start_time: 'Thu, 18 Feb 2016 12:00:00 UTC +00:00', end_time:'Thu, 18 Feb 2016 17:00:00 UTC +00:00', streaming_url:'streaming event',  }])


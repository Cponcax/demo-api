# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Channel.create(name: 'canal cuatro',streaming_url: 'streaming_url_canalcuatro', position: 4, logo_color: 'verde')

Schedule.create(channel_id: 1 , date:"#{Time.current}", name: 'Programacion canal dos', turn: 'manana')

 Show.create(name: 'Viva la manana' , rating: 'Para todo publico')

 Event.create(show_id: 1, schedule_id: 1, start_time: "#{Time.current}", end_time:'Thu, 18 Feb 2016 17:00:00 UTC +00:00', streaming_url:'streaming event')


Channel.create(name: 'canal dos',  streaming_url: 'streaming_url_canaldos', position:2 )

Schedule.create(channel_id: 2 , date:'Thu, 18 Feb 2016 16:00:45 UTC +00:00', name: 'Programacion cuatro', turn: 'tarde')

Show.create(name: 'A todo o nada ' ,  rating: 'Para todo publico')

Event.create(show_id: 2, schedule_id: 2, start_time: 'Thu, 18 Feb 2016 18:00:00 UTC +00:00', end_time:'Thu, 18 Feb 2016 22:00:00 UTC +00:00', streaming_url:'streaming event')

class V1::ChannelsController < V1::BaseController
  before_action :set_channel, only: [:show, :channel_shows]


  def index
    @channels = Channel.all
    render json: @channels
  end

  def show
    render json: @channel
  end


 api :GET, "/channels/:id/schedules?day=1", "Get list of programs per channel per schedules per day. Where monday is 1 and sunday is 7"


    param :id, Integer, :desc => "id of channel" , :required => true
    param :day, Integer, :desc => "day of the week  ", :required => true


  formats ['json']
  example'

{
  "Events":[
    {
    "id": 1,
    "name": "TCS noticias",
    "rating": "nc_17",
    "logo": "/system/shows/logos/1/download_%282%29_original.jpeg?1457453604",
    "datetime": "2016-03-07T06:14:00.000+00:00",
    "cover": "/system/shows/covers/1/download_%283%29_original.jpeg?1457453604",
    "turn": "morning"
    }
  ]
  '
  def channel_shows
    day =  params[:day]
    unixdate = params[:date]
    date = unixdate.to_i
    date_parse = Time.at(date).to_datetime
    # date_conver = DateTime.parse(date)
    #date_current_parse = date_parse.new_offset(DateTime.now.offset)
    date_current = DateTime.now
    case
    when day == "1" && date_parse.hour == date_current.hour
      @channel.monday
      render json: @channel.monday, root: "events"
    when day == "2"
      @channel.tuesday
      render json: @channel.tuesday, root: "events"
    when day == "3"
      @channel.wednesday
      render json: @channel.wednesday, root: "events"
    when day == "4"
      @channel.thursday
      render json: @channel.thursday, root: "events"
    when day == "5"
      @channel.friday
      render json: @channel.friday, root: "events"
    when day == "6"
      @channel.saturday
      render json: @channel.saturday, root: "events"
    when day == "7"
      @channel.sunday
      render json: @channel.sunday, root: "events"
    else
     render json: @channel.errors, status: 404
    end
  end


  private


    def set_channel
      @channel = Channel.find(params[:id])
    end

    def channel_params
      params.require(:channel).permit(:name, :streaming_url, :position, :logo_color)
    end
end

class V1::ChannelsController < V1::BaseController
  before_action :set_channel, only: [:show, :channel_shows]


  def index
    @channels = Channel.all
    render json: @channels
  end

  def show
    render json: @channel
  end


 api :GET, "/channels/:id/schedules?day=1&date=1458166403", "Get list of programs per channel per schedules per day. Where monday is 1 and sunday is 7"
    param :id, Integer, :desc => "Id of the channel" , :required => true
    param :day, Integer, :desc => "Day of the week in number where Mondar is 1 and Sunday is 0", :required => true
    param :date, Integer, :desc => "Date in format Unix timestamp ", :required => true
    formats ['json']
    example'
{
  "Events":[
    {
      "id": 17,
      "channel_id": 1,
      "name": "Viva la manana",
      "cover": "https://503development.s3.amazonaws.com/shows/covers/2/download_%285%29_original.jpeg?1457643848",
      "logo": "https://503development.s3.amazonaws.com/shows/logos/2/hqdefault_original.jpg?1457643848",
      "rating": "g",
      "datetime": "2016-03-16T15:00:00.000-06:00"
    }
  ]
}
  '
    def channel_shows
      day =  params[:day]
      unixdate = params[:date]
      date = unixdate.to_i
      date_parse = Time.at(date).to_datetime
      date_current = DateTime.now
      @channel.event_with_date(day,date_parse)
      render json: @channel.event_with_date(day, date_parse), root: "events"
    end

  private

    def set_channel
      @channel = Channel.find(params[:id])
    end

    def channel_params
      params.require(:channel).permit(:name, :streaming_url, :position, :logo_color)
    end
end

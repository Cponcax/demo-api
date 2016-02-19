class V1::ChannelsController < V1::BaseController
  before_action :set_channel, only: [:show, :channel_shows]

  respond_to :html

  def index
    @channels = Channel.all
    render json: @channels
  end

  def show
    render json: @channel
  end


 api :GET, "/channels/:id/shows", "View shows per channel"
  param_group :error, V1::BaseController
  param :shows, Hash, :desc => "Contains show information.", :required => true do
    param :channel_id, :number, :required => true
     param :schedule_id, :number, :required => true
    param :name, String, :desc => "show name" , :required => true
    param :cover, String, :desc => "cover of the ", :required => true
    param :start_time, String, :desc => "start time ", :required => true
    param :end_time, String, :desc => "end time ", :required => true
    param :streaming_url, String, :desc => "streaming url for event", :required => true
    param :date, Date, :desc => "Date of the event", :required => true
  end
  formats ['json']
  example'
  {
    "shows":[
    {
    "channel_id": 2,
    "schedule": "tarde",
    "name": "viva la manana",
    "cover": "https://i.ytimg.com/vi/Q0NzALRJifI/maxresdefault.jpg",
    "start_time": "2016-02-16T16:10:30.000Z",
    "end_time": "2016-02-16T18:10:30.000Z",
    "streaming_url": "streaming event",
    "date": "2016-02-16"
    }
  ]
}
  '
  def channel_shows
    @channel.give_shows
    render json: @channel.give_shows, root: "shows"
  end

 
  private
    def set_channel
      @channel = Channel.find(params[:id])
    end

    def channel_params
      params.require(:channel).permit(:name, :logo, :streaming_url, :position)
    end
end

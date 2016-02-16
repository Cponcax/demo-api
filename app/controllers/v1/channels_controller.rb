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



  def channel_shows
    @channel.give_shows
    render json: @channel.give_shows, root: "shows"
  end
  formats ['json']
  example'
  {
    "shows":[
    {
    "channel_id": 2,
    "schedule": "tarde",
    "name": "viva la manana",
    "cover": "coverviva",
    "start_time": "2016-02-16T16:10:30.000Z",
    "end_time": "2016-02-16T18:10:30.000Z",
    "streaming_url": "streaming event4",
    "date": "2016-02-16"
    }
  ]
}
  '
  private
    def set_channel
      @channel = Channel.find(params[:id])
    end

    def channel_params
      params.require(:channel).permit(:name, :logo, :streaming_url, :position)
    end
end

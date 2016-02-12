class V1::ChannelsController < V1::BaseController
  before_action :set_channel, only: [:show, :edit, :update, :destroy, :channel_show]

  respond_to :html

  def index
    @channels = Channel.all
    render json: @channels
  end

  def show
    render json: @channel
  end

  def new
    @channel = Channel.new
    render json: @channel
  end

  def edit
  end

  def create
    @channel = Channel.new(channel_params)
    @channel.save
    render json: @channel
  end

  def update
    @channel.update(channel_params)
    render json: @channel
  end

  def destroy
    @channel.destroy
    render json: @channel
  end

  def channel_show
    @channel.get_name
    render json: @channel
  end

  private
    def set_channel
      @channel = Channel.find(params[:id])
    end

    def channel_params
      params.require(:channel).permit(:name, :logo, :streaming_url, :position)
    end
end

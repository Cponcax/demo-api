class V1::EventsController < V1::BaseController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @events = Event.all
    render json: @events
  end

  def show
    render json: @event
  end

  private
    def set_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(:streaming_url, :days)
    end
end

class V1::EventsController < V1::BaseController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

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
      params.require(:event).permit(:start_time, :end_time,:streaming_url)
    end
end

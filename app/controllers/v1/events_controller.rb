class V1::EventsController < V1::ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @events = Event.all
    render json: @events
  end

  def show
    render json: @event
  end

  def new
    @event = Event.new
    render json: @event
  end

  def edit
  end

  def create
    @event = Event.new(event_params)
    @event.save
    render json: @event
  end

  def update
    @event.update(event_params)
    render json: @event
  end

  def destroy
    @event.destroy
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

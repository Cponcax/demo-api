class  V1::ShowsController < V1::ApplicationController
  before_action :set_show, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @shows = Show.all
    render json: @shows
  end

  def show
    render json: @show
  end

  def new
    @show = Show.new
    render json: @show
  end

  def edit
  end

  def create
    @show = Show.new(show_params)
    @show.save
    render json: @show
  end

  def update
    @show.update(show_params)
    render json: @show
  end

  def destroy
    @show.destroy
    render json: @show
  end

  private
    def set_show
      @show = Show.find(params[:id])
    end

    def show_params
      params.require(:show).permit(:name, :logo, :cover)
    end
end

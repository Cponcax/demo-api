class V1::SchedulesController < V1::BaseController
  before_action -> { doorkeeper_authorize! :write }
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]


  def index
    @schedules = Schedule.all
    render json: @schedules
  end

  def show
    render json: @schedule
  end


  private
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    def schedule_params
      params.require(:schedule).permit(:date, :name, :turn)
    end
end

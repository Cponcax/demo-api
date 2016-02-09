class V1::SchedulesController < V1::BaseController
  before_action :set_schedule, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @schedules = Schedule.all
    render json: @schedules
  end

  def show
    render json: @schedule
  end

  def new
    @schedule = Schedule.new
    render json: @schedule
  end

  def edit
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.save
    render json: @schedule
  end

  def update
    @schedule.update(schedule_params)
    render json: @schedule
  end

  def destroy
    @schedule.destroy
    render json: @schedule
  end

  private
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end

    def schedule_params
      params.require(:schedule).permit(:start, :name, :days)
    end
end

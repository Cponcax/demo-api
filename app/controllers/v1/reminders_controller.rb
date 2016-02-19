class V1::RemindersController < V1::BaseController
  before_action -> { doorkeeper_authorize! :write }
  before_action :set_reminder, only: [:destroy]

  respond_to :html

  def index
    @reminders = current_resource_owner.reminders

    render json: @reminders
  end

  api :POST, "/reminders", "Create a reminder"
  param_group :error, V1::BaseController
  param :reminder, Hash, :desc => "Contains reminder information.", :required => true do
    param :schedule_id, :number, :required => true
    param :name, String, :desc => "Program name", :required => true
    param :url_image, String, :desc => "Url image of the program", :required => true
  end
  formats ['json']
  example '
  {
    "reminder": {
      "schedule_id": 1,
      "channel_id": 1,
      "name":"Metrópolis",
      "url_image":"https://i.ytimg.com/vi/Q0NzALRJifI/maxresdefault.jpg",
      "start_time": "2016-02-19T19:13:26.000Z"
    }
  }'
  def create
    @reminder = current_resource_owner.reminders.new(reminder_params)

    if @reminder.save
      render json: @reminder, status: :created
    else
      render json: @reminder.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, "/reminders/:id", "Destroy a reminder"
  param_group :error, V1::BaseController
  param :id, :number, :required => true
  formats ['json']
  def destroy
    @reminder.destroy
    head :no_content
  end

  private
    def set_reminder
      @reminder = current_resource_owner.reminders.find(params[:id])
    end

    def reminder_params
      params.require(:reminder).permit(:channel_id, :schedule_id, :name, :url_image, :start_time)
    end
end

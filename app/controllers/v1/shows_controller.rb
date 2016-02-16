class  V1::ShowsController < V1::BaseController
  before_action :set_show, only: [:show]

  respond_to :html

  def index
    @shows = Show.all
    render json: @shows
  end

  def show
    render json: @show
  end

  def shows_live
    @shows = Show.get_show
    render json: @shows
  end
  example'
  {
  "shows":[
        {
          "id": 1,
          "name": "grandiosas",
          "logo": "logograndiosas",
          "cover": "covergrandiosas"
        },
        {
          "id": 1,
          "name": "Viva la manana",
          "logo": "logo viva",
          "cover": "cover viva"
        }
      ]
    }
  '
  private
    def set_show
      @show = Show.find(params[:id])
    end

    def show_params
      params.require(:show).permit(:name, :logo, :cover)
    end
end

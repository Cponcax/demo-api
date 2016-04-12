class  V1::ShowsController < V1::BaseController
  #before_action -> { doorkeeper_authorize! :write }
  before_action :set_show, only: [:show]

  respond_to :html

  def index
    @shows = Show.all
    render json: @shows
  end

  def show
    render json: @show
  end
  api :GET, "/shows/live", "View shows live "

  formats ['json']
  example'
  {
  "shows":[
        {
          "id": 1,
          "name": "grandiosas",
          "logo": "https://i.ytimg.com/vi/Q0NzALRJifI/maxresdefault.jpg",
          "cover": "https://i.ytimg.com/vi/Q0NzALRJifI/maxresdefault.jpg"
        }
      ]
    }
  '
  def shows_live
    @shows = Show.get_show
    render json: @shows
  end


  private
    def set_show
      @show = Show.find(params[:id])
    end

    def show_params
      params.require(:show).permit(:name, :rating)
    end
end

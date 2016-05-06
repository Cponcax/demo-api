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
    ip_address = request.remote_ip 
 
    puts "REMOTE_IP::" + ip_address.inspect

    c = GeoIP.new('lib/geoip/GeoIP.dat').country(ip_address)
    
    country = c.country_code2

    render json: Show.live(country)
  end


  private
    def set_show
      @show = Show.find(params[:id])
    end

    def show_params
      params.require(:show).permit(:name, :rating)
    end
end


class V1::RatingsController < V1::BaseController
  before_action :set_rating, only: [:show]

  respond_to :html

  def index
    @ratings = Rating.all
    render json: @ratings
  end

  def show
    render json: @rating
  end



  private
    def set_rating
      @rating = Rating.find(params[:id])
    end

    def rating_params
      params.require(:rating).permit(:name)
    end
end

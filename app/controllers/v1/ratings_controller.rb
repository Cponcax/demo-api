class V1::RatingsController < V1::BaseController
  before_action :set_rating, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @ratings = Rating.all
    respond_with(@ratings)
  end

  def show
    respond_with(@rating)
  end



  private
    def set_rating
      @rating = Rating.find(params[:id])
    end

    def rating_params
      params.require(:rating).permit(:name)
    end
end

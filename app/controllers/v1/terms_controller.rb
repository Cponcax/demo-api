class V1::TermsController < V1::BaseController
  before_action :set_term, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def get_term
    @terms = Term.first
      render json: @terms
  end


  private
    def set_term
      @term = Term.find(params[:id])
    end

    def term_params
      params.require(:term).permit(:term)
    end
end

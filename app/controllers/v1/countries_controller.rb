class V1::CountriesController < V1::BaseController
  before_action :set_country, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @countries = Country.all
    respond_with(@countries)
  end

  def show
    respond_with(@country)
  end

  def create
    @country = Country.new(country_params)
    @country.save
    respond_with(@country)
  end

  def update
    @country.update(country_params)
    respond_with(@country)
  end

  def destroy
    @country.destroy
    respond_with(@country)
  end

  private
    def set_country
      @country = Country.find(params[:id])
    end

    def country_params
      params[:country]
    end
end

class V1::SubscriptionsController < V1::BaseController
  before_action :set_subscription, only: [:show, :edit, :update, :destroy]


  def index
    @subscriptions = Subscription.all
    render json: @subscriptions
  end

  def show
    render json: @subscription
  end

  def new
    @subscription = Subscription.new
    render json: @subscription
  end

  def edit
  end

  def create
    @subscription = Subscription.new(subscription_params)
    @subscription.save
    render json: @subscription
  end

  def update
    @subscription.update(subscription_params)
    render json: @subscription
  end

  def destroy
    @subscription.destroy
    render json: @subscription
  end

  #methods to payment
  def authorizer
    puts "HOLAAAA:::::::::::"
  puts "authorization code::: " + params[:authorization_code].inspect
    @result = Subscription.getAccessToken(params[:authorization_code])

    if @result
      render json: { message: "Ok" }, status: :ok
    else
      render json: { error: "Fail" }, status: :unprocessable_entity
    end
  end

  private
    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    def subscription_params
      params.require(:subscription).permit(:start_date, :end_date)
    end
end

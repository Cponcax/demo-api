class V1::SubscriptionsController < V1::BaseController
  before_action -> { doorkeeper_authorize! :write }
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
  def authorize
    # puts "USER" + current_resource_owner.inspect
    # puts "RECUESS" + request.headers.inspect
    # puts "CODE:::: "  + params[:authorization_code]
    @result = Subscription.getAccessToken(current_resource_owner, params[:authorization_code])

    if @result
      render json: { message: "Ok" }, status: :ok
    else
      render json: { error: "Fail" }, status: :unprocessable_entity
    end
  end

  def payment
    puts "metadata_id::: " + params[:metadata_id]
    @result = Subscription.makePayment(current_resource_owner, params[:metadata_id])

    if @result
      render json: { message: "Ok" }, status: :ok
    else
      render json: { error: "Fail" }, status: :unprocessable_entity
    end
  end

  def status
    @payment = Payment.find('PAY-2WT75022387566739K4GUCAA')
    render json: @payment
  end

  private
    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    def subscription_params
      params.require(:subscription).permit(:start_date, :end_date)
    end
end

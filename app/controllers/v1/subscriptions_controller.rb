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
    user = current_resource_owner
    token = user.access_tokens
    puts "USER" + token.inspect
    #puts "RECUESS" + request.headers.inspect
    puts "CODE:::: "  + params[:authorization_code]
    @result = Subscription.getAccessToken(current_resource_owner, params[:authorization_code])

    if @result
      render json: { message: "Ok" }, status: :ok
    else
      render json: { error: "Fail" }, status: :unprocessable_entity
    end
  end

  def payment
    puts "metadata_id::: " + params[:metadata_id]
    user = current_resource_owner
    if user.subscriptions.present? == false
    @result = Subscription.firtsMakePayment(current_resource_owner, params[:metadata_id])

    else
      @result = Subscription.makePayment(current_resource_owner, params[:metadata_id])
    end

    if @result
      render json: { message: "Ok" }, status: :ok
    else
      render json: { error: "Fail" }, status: :unprocessable_entity
    end
  end

  def status
    @payment = Subscription.status(current_resource_owner)
    

    render json: @payment
  end

  def cancel
    puts "ENTRASTE"
    @cancel = Subscription.remove(current_resource_owner)
     
     puts "RESPUESTA" + @cancel.inspect
    if @cancel 
      render json: {message: "Delete"}, status: :ok
    else
      render json: {error: "Fail"}, status: :unprocessable_entity
    end
  end

  #method for save supcription to Iphone
  def sync
    @sym = Subscription.PaymentIos(current_resource_owner, params[:start_date], 
      params[:end_date], params[:transaction_id], params[:identifier], params[:cancelled])

    if @sym 
      render json: {message: "OK"}, status: :ok
    else
      render json: {error: "Fail"}, status: :unprocessable_entity
    end
  end

  private
    def set_subscription
      @subscription = Subscription.find(params[:id])
    end

    def subscription_params
      params.require(:subscription).permit(:start_date, :end_date,:transaction_id, :identifier, :cancelled)
    end
end

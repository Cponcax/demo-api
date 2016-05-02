class V1::SubscriptionsController < V1::BaseController
  before_action -> { doorkeeper_authorize! :write }
  before_action :set_subscription, only: [:show, :edit, :update, :destroy]

  #methods to payment
  def authorize
    # user = current_resource_owner
    # token = user.access_tokens
    # puts "USER" + token.inspect
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

    if user.subscriptions.present? == false || user.subscriptions.last.cancelled == true
      puts " PRIMERA SUBCRIPTIONS::::::"
      @result = Subscription.firstMakePayment(current_resource_owner, params[:metadata_id])
    elsif  user.subscriptions.last.cancelled  == false
      puts "RECURRENTE PAGO  SUB::::"
      @result = Subscription.recurringPayment(current_resource_owner, params[:metadata_id])
    else
     puts "YA TIENES SUBCRIPTIONS:::::::"
    end
    puts "RESULT:::" + @result.inspect
    #binding.pry
    if @result.error.nil?
      render json: { message: "Ok" }, status: :ok
    elsif @result.present? == false
     render json: {message: "you already have a subscriptions"}, status: :unprocessable_entity
    else @result.error.name == "TRANSACTION_REFUSED"
      render json: { error: "Fail" }, status: 400
    end
  end


  def status
  
  @subscription = Subscription.status(current_resource_owner)

    if @subscription.present? == false
      puts"NO TIENES SUB:::" + @subscription.inspect
      render json: {message: "you do not have subscriptions"}, status: :unprocessable_entity
    elsif @subscription.cancelled? == false
      t = Date.current

      dates = (@subscription.start_date.to_date..@subscription.end_date.to_date).to_a

      status = dates.include? t 

      puts "TIENES SUB" + @subscription.inspect
      render json: {cancelled: @subscription.cancelled, status: status}, status: :ok, root: false
    end
  end

  def cancel
    puts "ENTRASTE"
    @cancel = Subscription.cancel(current_resource_owner)

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
      params.require(:subscription).permit(:start_date, :end_date,:transaction_id, :identifier, :cancelled, :payment)
    end
end

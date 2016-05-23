class V1::SubscriptionsController < V1::BaseController
  before_action -> { doorkeeper_authorize! :write }
  before_action :set_subscription, only: [:status, :cancel]

  def status
    if @subscription
      render json: @subscription.info, status: 200, root: false
    else
      render json: {}, status: 422
    end
  end

  def authorize
    begin
      customer = current_resource_owner.customers.first_or_create

      if customer && customer.exch_token(params[:authorization_code])
        render json: {}, status: 200
      end
    rescue Exception => e
      render json: { error: e.message }, status: 422
    end
  end

  def payment
    puts "metadata_id::: " + params[:metadata_id]

    user = current_resource_owner

    if user.subscriptions.present? == false || user.subscriptions.last.cancelled == true
      puts " PRIMERA SUBCRIPTIONS::"
      @result = Subscription.firstMakePayment(current_resource_owner, params[:metadata_id])
    elsif  user.subscriptions.last.cancelled  == false
      puts "RECURRENTE PAGO  SUB::"
      @result = Subscription.recurringPayment(current_resource_owner, params[:metadata_id])
    else
     puts "YA TIENES SUBCRIPTIONS::"
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

  def cancel
    if @subscription.cancel
      render json: {}, status: 200
    else
      render json: {}, status: 422
    end
  end

  private
    def set_subscription
      @subscription = current_resource_owner.get_current_subscription
    end

    def subscription_params
      params.require(:subscription).permit(:start_date, :end_date,:transaction_id, :identifier, :cancelled, :payment)
    end
end

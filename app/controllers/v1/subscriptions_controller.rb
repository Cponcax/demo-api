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
    puts "metadata_id in payment method is::: " + params[:metadata_id]

    payment = current_resource_owner.get_current_customer.make_payment params[:metadata_id]

    puts "PAYMENT(FUTURE PAYMENT IS):: " + payment.inspect

    if payment.error.nil?
      render json: {}, status: 200
    else
      render json: {}, status: 400
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
end

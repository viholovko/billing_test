class Api::V1::PaymentsController < Api::V1::BaseController
  def create
    subscription = Subscription.find(params[:subscription_id])
    amount = subscription.amount

    result = PaymentRebillingService.new(subscription).attempt_rebill(amount)

    if result[:success]
      render json: { message: "Payment processed successfully." }, status: :ok
    else
      render json: { message: result[:error] }, status: :unprocessable_entity
    end
  end
end
class RebillJob < ApplicationJob
  queue_as :default

  def perform(subscription_id, remaining_amount)
    subscription = Subscription.find(subscription_id)
    PaymentRebillingService.new(subscription).attempt_rebill(remaining_amount)
  end
end
class PaymentRebillingService
  MAX_ATTEMPTS = 4
  RETRY_AMOUNTS = [1.0, 0.75, 0.50, 0.25].freeze

  def initialize(subscription)
    @subscription = subscription
    @attempts = 0
  end

  def attempt_rebill(amount)
    RETRY_AMOUNTS.each do |fraction|
      @attempts += 1
      return { success: false, error: "Max attempts reached." } if @attempts > MAX_ATTEMPTS

      retry_amount = (amount * fraction).round(2)
      response = simulate_payment(retry_amount)

      log_payment_attempt(retry_amount, response[:status])

      if response[:status] == "success"
        remaining_amount = amount - retry_amount
        schedule_remaining_payment(remaining_amount) if remaining_amount > 0
        return { success: true }
      end
    end

    { success: false, error: "All rebill attempts failed." }
  end

  private

  def simulate_payment(amount)
    mock_payment_response(amount)
  end

  def mock_payment_response(amount)
    if amount > rand(10..100) # Simulate success/failure.
      { status: "insufficient_funds" }
    else
      { status: "success" }
    end
  end

  def log_payment_attempt(amount, status)
    # Map the response status to valid payment statuses
    valid_status = case status
                   when "success"
                     "completed"
                   when "insufficient_funds"
                     "failed"
                   else
                     "failed"  # Default to failed for any unexpected status
                   end

    Payment.create!(
      subscription: @subscription,
      amount: amount,
      status: valid_status  # Use the mapped valid status
    )
  end

  def schedule_remaining_payment(remaining_amount)
    # Logic to enqueue a job or create a scheduled task for a week later.
    RebillJob.set(wait: 1.week).perform_later(@subscription.id, remaining_amount)
  end
end
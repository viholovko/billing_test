require 'rails_helper'

RSpec.describe PaymentRebillingService do
  let(:subscription) { create(:subscription) }  # Assuming you have a subscription factory
  let(:service) { described_class.new(subscription) }

  describe '#attempt_rebill' do
    context 'when payment is successful' do
      it 'returns success when the payment is successful on the first attempt' do
        allow(service).to receive(:mock_payment_response).and_return({ status: "success" })

        result = service.attempt_rebill(100.0)

        expect(result).to eq({ success: true })
      end

      it 'returns success when the payment is successful after retries' do
        allow(service).to receive(:mock_payment_response).and_return({ status: "insufficient_funds" }, { status: "success" })

        result = service.attempt_rebill(100.0)

        expect(result).to eq({ success: true })
      end
    end

    context 'when payment fails' do
      it 'returns failure after all attempts fail' do
        allow(service).to receive(:mock_payment_response).and_return({ status: "insufficient_funds" })

        result = service.attempt_rebill(100.0)

        expect(result).to eq({ success: false, error: "All rebill attempts failed." })
      end

      it 'returns failure when max attempts are reached' do
        allow(service).to receive(:mock_payment_response).and_return({ status: "insufficient_funds" })

        service.instance_variable_set(:@attempts, 4)  # Simulate max attempts reached

        result = service.attempt_rebill(100.0)

        expect(result).to eq({ success: false, error: "Max attempts reached." })
      end
    end

    context 'when logging payment attempts' do
      it 'creates a payment record for each attempt' do
        allow(service).to receive(:mock_payment_response).and_return({ status: "insufficient_funds" }, { status: "success" })

        expect {
          service.attempt_rebill(20.0)
        }.to change { Payment.count }.by(2)  # One for each attempt
      end
    end

    context 'when scheduling remaining payments' do
      it 'schedules a job for remaining payment' do
        allow(service).to receive(:mock_payment_response).and_return({ status: "success" })
        expect(service).to receive(:schedule_remaining_payment).with(10.0)  # Assuming the first attempt is 50.0
        service.attempt_rebill(10.0)
      end
    end
  end
end 
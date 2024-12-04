require 'rails_helper'

RSpec.describe RebillJob, type: :job do
  let(:subscription) { create(:subscription) }  # Assuming you have a subscription factory
  let(:remaining_amount) { 100.0 }  # Example remaining amount

  describe '#perform' do
    it 'calls attempt_rebill on PaymentRebillingService' do
      service = instance_double(PaymentRebillingService)
      allow(PaymentRebillingService).to receive(:new).with(subscription).and_return(service)
      expect(service).to receive(:attempt_rebill).with(remaining_amount)

      RebillJob.perform_now(subscription.id, remaining_amount)
    end

    it 'finds the subscription by id' do
      expect(Subscription).to receive(:find).with(subscription.id).and_call_original

      RebillJob.perform_now(subscription.id, remaining_amount)
    end

    it 'raises an error if the subscription is not found' do
      expect {
        RebillJob.perform_now(-1, remaining_amount)  # Assuming -1 is an invalid ID
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end 
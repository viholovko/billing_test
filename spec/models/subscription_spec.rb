require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:subscription) { create(:subscription) }  # Assuming you have a subscription factory

  describe 'Model.Subscription relationships' do
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to have_many(:payments).dependent(:destroy) }
  end

  describe 'Model.Subscription validations' do
    it 'is valid with valid attributes' do
      expect(subscription).to be_valid
    end

    it 'is not valid without a customer' do
      subscription.customer = nil
      expect(subscription).to_not be_valid
    end

    it 'is not valid without an amount' do
      subscription.amount = nil
      expect(subscription).to_not be_valid
    end

    it 'is not valid with a negative outstanding balance' do
      subscription.outstanding_balance = -1.0
      expect(subscription).to_not be_valid
    end
  end

  describe '#add_outstanding_balance' do
    it 'increases the outstanding balance by the given amount' do
      initial_balance = subscription.outstanding_balance
      amount_to_add = 50.0

      subscription.add_outstanding_balance(amount_to_add)

      expect(subscription.outstanding_balance).to eq(initial_balance + amount_to_add)
    end

    it 'saves the subscription after adding to the outstanding balance' do
      amount_to_add = 50.0

      expect {
        subscription.add_outstanding_balance(amount_to_add)
      }.to change { subscription.reload.outstanding_balance }.by(amount_to_add)
    end

    it 'raises an error if the amount is negative' do
      expect {
        subscription.add_outstanding_balance(-10.0)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end 
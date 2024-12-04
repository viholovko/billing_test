require 'rails_helper'

RSpec.describe Payment, type: :model do
  describe 'Model.Payment relationships' do
    it { is_expected.to belong_to(:subscription) }
  end

  describe 'Model.Payment validations' do
    it 'is valid with valid attributes' do
      payment = FactoryBot.build(:payment, subscription: FactoryBot.build(:subscription))
      expect(payment).to be_valid
    end

    it 'is not valid without a subscription' do
      payment = FactoryBot.build(:payment, subscription: nil)
      expect(payment).to_not be_valid
    end

    it 'is not valid without an amount' do
      payment = FactoryBot.build(:payment, amount: nil)
      expect(payment).to_not be_valid
    end

    it 'is not valid with a negative amount' do
      payment = FactoryBot.build(:payment, amount: -1.0)
      expect(payment).to_not be_valid
    end

    it 'is not valid with an invalid status' do
      payment = FactoryBot.build(:payment, status: 'invalid_status')
      expect(payment).to_not be_valid
    end
  end 
end 
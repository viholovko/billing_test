require 'rails_helper'

RSpec.describe Customer, type: :model do

  describe ' Model.Customer relationships' do
    it { is_expected.to have_many(:subscriptions).dependent(:destroy) }
  end

  describe ' Model.Customer' do
    it 'is valid with valid attributes' do
      customer = FactoryBot.build(:customer)
      expect(customer).to be_valid
    end

    it 'is not valid with an invalid email' do
      customer = FactoryBot.build(:customer, :with_invalid_email)
      expect(customer).to_not be_valid
    end

    it 'is not valid without a phone number' do
      customer = FactoryBot.build(:customer, :without_phone)
      expect(customer).to_not be_valid
    end
  end 
end 
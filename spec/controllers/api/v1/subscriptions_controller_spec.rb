require 'rails_helper'

RSpec.describe Api::V1::SubscriptionsController, type: :controller do
  let!(:subscription) { create(:subscription) }  # Assuming you have a subscription factory

  describe 'GET #index' do
    it 'returns a list of subscriptions' do
      get :index
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(1)  # Adjust based on the number of subscriptions created
    end
  end

  describe 'GET #show' do
    it 'returns the requested subscription' do
      get :show, params: { id: subscription.id }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['id']).to eq(subscription.id)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_attributes) { { subscription: { customer_id: subscription.customer_id, amount: 100.0, outstanding_balance: 0.0 } } }

      it 'creates a new subscription' do
        expect {
          post :create, params: valid_attributes
        }.to change(Subscription, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      it 'returns the created subscription' do
        post :create, params: valid_attributes
        expect(JSON.parse(response.body)['amount'].to_f).to eq(100.0)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { subscription: { customer_id: nil, amount: nil, outstanding_balance: nil } } }

      it 'does not create a new subscription' do
        expect {
          post :create, params: invalid_attributes
        }.to change(Subscription, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        post :create, params: invalid_attributes
        expect(JSON.parse(response.body)).to have_key('customer')
        expect(JSON.parse(response.body)).to have_key('amount')
        expect(JSON.parse(response.body)).to have_key('outstanding_balance')
      end
    end
  end

  describe 'PATCH/PUT #update' do
    context 'with valid parameters' do
      let(:new_attributes) { { subscription: { amount: 150.0 } } }

      it 'updates the requested subscription' do
        patch :update, params: { id: subscription.id }.merge(new_attributes)
        subscription.reload
        expect(subscription.amount).to eq(150.0)
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { subscription: { amount: nil } } }

      it 'does not update the subscription' do
        patch :update, params: { id: subscription.id }.merge(invalid_attributes)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the requested subscription' do
      subscription_to_delete = create(:subscription)  # Create a subscription to delete
      expect {
        delete :destroy, params: { id: subscription_to_delete.id }
      }.to change(Subscription, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end 
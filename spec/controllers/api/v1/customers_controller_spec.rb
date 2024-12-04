require 'rails_helper'

RSpec.describe Api::V1::CustomersController, type: :controller do
  let!(:customer) { create(:customer) }  # Assuming you have a customer factory

  describe 'GET #index' do
    it 'returns a list of customers' do
      get :index
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).size).to eq(1)  # Adjust based on the number of customers created
    end
  end

  describe 'GET #show' do
    it 'returns the requested customer' do
      get :show, params: { id: customer.id }
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['id']).to eq(customer.id)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_attributes) { { customer: { name: 'John Doe', email: 'john@example.com', phone: '123-456-7890' } } }

      it 'creates a new customer' do
        expect {
          post :create, params: valid_attributes
        }.to change(Customer, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      it 'returns the created customer' do
        post :create, params: valid_attributes
        expect(JSON.parse(response.body)['name']).to eq('John Doe')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { customer: { name: '', email: 'invalid_email', phone: '' } } }

      it 'does not create a new customer' do
        expect {
          post :create, params: invalid_attributes
        }.to change(Customer, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns error messages' do
        post :create, params: invalid_attributes
        expect(JSON.parse(response.body)).to have_key('name')
        expect(JSON.parse(response.body)).to have_key('email')
      end
    end
  end

  describe 'PATCH/PUT #update' do
    context 'with valid parameters' do
      let(:new_attributes) { { customer: { name: 'Jane Doe' } } }

      it 'updates the requested customer' do
        patch :update, params: { id: customer.id }.merge(new_attributes)
        customer.reload
        expect(customer.name).to eq('Jane Doe')
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { customer: { email: 'invalid_email' } } }

      it 'does not update the customer' do
        patch :update, params: { id: customer.id }.merge(invalid_attributes)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the requested customer' do
      customer_to_delete = create(:customer)  # Create a customer to delete
      expect {
        delete :destroy, params: { id: customer_to_delete.id }
      }.to change(Customer, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end 
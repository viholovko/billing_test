class Api::V1::CustomersController < Api::V1::BaseController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  
  # GET /customers
  def index
    @customers = Customer.all
    render json: @customers
  end

  # GET /customers/:id
  def show
    set_customer
    render json: @customer
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # POST /customers
  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      render json: @customer, status: :created
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  # GET /customers/:id/edit
  def edit
  end

  # PATCH/PUT /customers/:id
  def update
    set_customer
    if @customer.update(customer_params)
      render json: @customer
    else
      render json: @customer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /customers/:id
  def destroy
    set_customer
    @customer.destroy
    head :no_content
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :email, :phone)
  end
end
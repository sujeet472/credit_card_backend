class Api::V1::CustomersController < Api::V1::BaseController
    # Skip CSRF protection if this is a pure API controller
    protect_from_forgery with: :null_session
  
    # GET /api/v1/customers
    def index
      customers = Customer.all
      render json: customers
    end
  
    # GET /api/v1/customers/:id
    def show
      customer = Customer.find_by(customer_id: params[:id])
      if customer
        render json: customer
      else
        render json: { error: "Customer not found" }, status: :not_found
      end
    end
  
    # POST /api/v1/customers
    def create
      customer = Customer.new(customer_params)
      if customer.save
        render json: customer, status: :created
      else
        render json: { errors: customer.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    # PATCH/PUT /api/v1/customers/:id
    def update
      customer = Customer.find_by(customer_id: params[:id])
      if customer&.update(customer_params)
        render json: customer
      else
        render json: { error: "Customer not found or update failed" }, status: :unprocessable_entity
      end
    end
  
    # DELETE /api/v1/customers/:id
    def destroy
      customer = Customer.find_by(customer_id: params[:id])
      if customer&.destroy
        render json: { message: "Customer deleted successfully" }
      else
        render json: { error: "Customer not found" }, status: :not_found
      end
    end
  
    private
  
    def customer_params
      params.permit(:customer_id, :password, :first_name, :last_name, :date_of_birth, :email, :phone_number, :address, :branch_id)
    end
  end
  
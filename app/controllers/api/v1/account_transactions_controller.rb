class Api::V1::AccountTransactionsController < Api::V1::BaseController
        before_action :set_account_transaction, only: %i[show update destroy]
        # skip_before_action :authenticate_request
        def index
          render json: AccountTransaction.kept
        end
      
        def show
          render json: @account_transaction
        end
      
        def create
          transaction = AccountTransaction.new(transaction_params)
          if transaction.save
            render json: transaction, status: :created
          else
            render json: transaction.errors, status: :unprocessable_entity
          end
        end
      
        def update
          if @account_transaction.update(transaction_params)
            render json: @account_transaction
          else
            render json: @account_transaction.errors, status: :unprocessable_entity
          end
        end
      
        def destroy
          @account_transaction.destroy
          head :no_content
        end
      
        private
      
        def set_account_transaction
          @account_transaction = AccountTransaction.kept.find(params[:id])
        end
      
        def transaction_params
          params.require(:account_transaction).permit(:user_card_id, :transaction_date, :amount, :merchant_id, :location, :transaction_type)
        end
end


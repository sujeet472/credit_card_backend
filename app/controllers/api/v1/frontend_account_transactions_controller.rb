class Api::V1::FrontendAccountTransactionsController < Api::V1::BaseController

    skip_before_action :verify_authenticity_token
    
    def index
        # Find the profile of the currently logged-in user
        profile = Profile.find_by(users_id: current_user.id)
        return render json: { error: 'Profile not found' }, status: :not_found unless profile
    
        # Get all active user cards associated with the profile
        user_card_ids = UserCard.where(profile_id: profile.id, is_active: true).pluck(:id)
    
        # Get all transactions where the user is either the payer or the merchant
        transactions = AccountTransaction.where(user_card_id: user_card_ids)
                                        .or(AccountTransaction.where(merchant_id: user_card_ids))
                                        .order(transaction_date: :desc)
    
        render json: transactions
      end


      def create
        profile = Profile.find_by(users_id: current_user.id)
        return render json: { error: 'Profile not found' }, status: :not_found unless profile
    
        # Validate that the user_card_id belongs to the logged-in user
        user_card = UserCard.find_by(id: transaction_params[:user_card_id], profile_id: profile.id, is_active: true)
        return render json: { error: 'Invalid card selected' }, status: :unprocessable_entity unless user_card
    
        # Create the transaction
        transaction = AccountTransaction.new(transaction_params)
        transaction.transaction_date = Time.current # Set transaction date to now
    
        if transaction.save
          render json: { message: 'Transaction created successfully', transaction: transaction }, status: :created
        else
          render json: { error: transaction.errors.full_messages }, status: :unprocessable_entity
        end
      end
    
      private
    
      def transaction_params
        params.require(:account_transaction).permit(:user_card_id, :amount, :merchant_id, :location, :transaction_type)
      end
    
end

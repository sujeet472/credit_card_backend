class Api::V1::FrontendAccountTransactionsController < ApplicationController
    def index
      # Find current user's profile
      profile = Profile.find_by(users_id: current_user.id)
  
      unless profile
        return render json: { error: "Profile not found" }, status: :not_found
      end
  
      # Get all user cards associated with the profile
      user_card_ids = UserCard.where(profile_id: profile.id).pluck(:id)
  
      # Get all transactions linked to these user cards
      transactions = AccountTransaction.where(user_card_id: user_card_ids)
  
      render json: transactions, status: :ok
    end
  end
  
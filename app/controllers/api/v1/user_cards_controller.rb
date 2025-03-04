class Api::V1::UserCardsController < Api::V1::BaseController
    before_action :authenticate_request
    before_action :set_user_card, only: %i[show update destroy]
  
    def index
      render json: UserCard.all
    end
  
    def show
      render json: @user_card
    end
  
    def create
      card = UserCard.new(card_params)
      if card.save
        render json: card, status: :created
      else
        render json: card.errors, status: :unprocessable_entity
      end
    end
  
    def update
      if @user_card.update(card_params)
        render json: @user_card
      else
        render json: @user_card.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      @user_card.destroy
      head :no_content
    end
  
    private
  
    def set_user_card
      @user_card = UserCard.find(params[:id])
    end
  
    def card_params
      params.require(:user_card).permit(:credit_card_id, :customer_id, :issue_date, :expiry_date, :cvv, :is_active, :available_limit)
    end
end
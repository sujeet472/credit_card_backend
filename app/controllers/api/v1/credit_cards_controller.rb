

class Api::V1::CreditCardsController < Api::V1::BaseController

    before_action :set_credit_card, only: %i[show update destroy discard]
    skip_before_action :verify_authenticity_token


    def index
        
        @credit_cards = CreditCard.kept
        render json: @credit_cards, status: :ok
    end

    def show
        @credit_card = CreditCard.kept.find(params[:id]) #credit_card_id: params[:id]
        render json: @credit_card, status: :ok
    end


    def create
        @credit_card = CreditCard.new(credit_card_params) 
        if @credit_card.save
            #redirect_to @credit_card #just a try to see what will happen
            render json: @credit_card, status: :created
        else
            render json: {errors: @credit_card.errors.full_messages},
                    status: :unprocessable_entity
        end
    end

    def update
        unless @credit_card.update(credit_card_params)
            render json: {errors: @credit_card.errors.full_messages},
                status: :unprocessable_entity
        end
    end

    def destroy
        if @credit_card.destroy
            render json: {message: "Credit card delted successfully"}, status: :ok
        else
            render json: {error: "Failed to delete credit card"}, status: :unprocessable_entity
        end
    end

    def discard
        if @credit_card.discard
            render json: {message: "Credit discarded successfully"}, status: :ok
        else
            render json: {error: "Failed to discard credit card"}, status: :unprocessable_entity
        end
    end

    
    def restore
        @credit_card = CreditCard.with_discarded.kept.find(params[:id])
        if @credit_card.undiscard
            render json: {message: "Credit restored successfully"}, status: :ok
        else
            render json: {error: "Failed to restore credit card"}, status: :unprocessable_entity
        end
    end


    private
    def set_credit_card
        @credit_card = CreditCard.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        flash[:alert] = "Credit card not found."
        redirect_to api_v1_credit_cards_path and return
    end

    def credit_card_params
        params.permit(:credit_card_id, :type_of_card, :credit_limit)
    end
end

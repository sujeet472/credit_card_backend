class UserCardsController < ApplicationController

    before_action :set_user_card, only: %i[show edit update destroy restore]


    def index
        @user_cards = UserCard.kept
    end

    def show
        @user_card = UserCard.kept.find(params[:id])
        # render json:@user_card
    end

    def new
        @user_card = UserCard.new
    end


    def create
        @user_card = UserCard.new(user_card_params)
        @user_card.cvv = params[:user_card][:cvv] # Manually assign cvv before saving
      
        if @user_card.save
          redirect_to user_card_path(@user_card), notice: "User card created successfully."
        else
          render :new, status: :unprocessable_entity  # return 422 if there is an error
        end
      end

      
    # def create

    #     @user_card = UserCard.new(user_card_params)
    #     @user_card.cvv = params[:user_card][:cvv] # Manually assign cvv
    #     byebug
    #     if @user_card.save
    #         redirect_to user_card_path(@user_card), notice: "User card created successfully."
    #     else
    #         render :new, status: :unprocessable_entity  # return 422 if there is an error
    #     end
    # end

    def edit
        @user_card = UserCard.kept.find(params[:id])
    end

    def update
        if @user_card.update
            redirect_to @user_card
        else
            render :edit, status: :unprocessable_entity
        end
    end
    
    def destroy
        @user_card.discard
        respond_to do |format|
          format.html { redirect_to user_cards_path, notice: "User Card was successfully discarded." }
          format.json { head :no_content }
        end
    end

    def restore
        @user_card.undiscard
        respond_to do |format|
          format.html { redirect_to user_card_path(@user_card), notice: "User Card restored successfully." }
          format.json { head :no_content }
        end
    end


    private
    def set_user_card
        @user_card = UserCard.kept.find_by(id: params[:id])
    rescue ActiveRecord::RecordNotFound
        flash[:alert] = "User Card not found."
        redirect_to user_cards_path and return
    end

    def user_card_params
        params.require(:user_card).permit(:id, :credit_card_id, :profile_id, :issue_date, :expiry_date, :is_active, :available_limit, :created_at, :updated_at, :cvv)
    end    

end

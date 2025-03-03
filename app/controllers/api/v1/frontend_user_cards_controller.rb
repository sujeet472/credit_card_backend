module Api
    module V1
      class FrontendUserCardsController < ApplicationController
        before_action :authenticate_user! # Ensure the user is logged in
        before_action :set_profile # Fetch profile of the logged-in user
        before_action :set_user_card, only: [:show, :update, :destroy]
  
        # GET /api/v1/frontend_user_cards
        def index
          @user_cards = UserCard.where(profile_id: @profile.id, discarded_at: nil)
          render json: @user_cards, status: :ok
        end
  
        # GET /api/v1/frontend_user_cards/:id
        def show
          render json: @user_card, status: :ok
        end
  
        # POST /api/v1/frontend_user_cards
        def create
          @user_card = UserCard.new(user_card_params)
          @user_card.profile_id = @profile.id # Assign profile_id of the logged-in user
  
          if @user_card.save
            render json: @user_card, status: :created
          else
            render json: { errors: @user_card.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        # PATCH/PUT /api/v1/frontend_user_cards/:id
        def update
          if @user_card.update(user_card_params)
            render json: @user_card, status: :ok
          else
            render json: { errors: @user_card.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        # DELETE /api/v1/frontend_user_cards/:id
        def destroy
          if @user_card.update(discarded_at: Time.current) # Soft delete
            render json: { message: 'Card discarded successfully' }, status: :ok
          else
            render json: { errors: @user_card.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        private
  
        # Fetch the profile associated with the current user
        def set_profile
          @profile = Profile.find_by(users_id: current_user.id, discarded_at: nil)
          render json: { error: 'Profile not found' }, status: :not_found unless @profile
        end
  
        # Fetch only the user's own card
        def set_user_card
          @user_card = UserCard.find_by(id: params[:id], profile_id: @profile.id, discarded_at: nil)
          render json: { error: 'Card not found' }, status: :not_found unless @user_card
        end
  
        # Strong parameters
        def user_card_params
          params.require(:user_card).permit(:credit_card_id, :issue_date, :expiry_date, :is_active, :available_limit, :hashed_cvv)
        end
      end
    end
  end
  
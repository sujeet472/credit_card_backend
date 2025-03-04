class Api::V1::RewardsController < Api::V1::BaseController
    before_action :set_reward, only: %i[show update destroy]
  
    def index
      render json: Reward.all
    end
  
    def show
      render json: @reward
    end
  
    def create
      reward = Reward.new(reward_params)
      if reward.save
        render json: reward, status: :created
      else
        render json: reward.errors, status: :unprocessable_entity
      end
    end
  
    def update
      if @reward.update(reward_params)
        render json: @reward
      else
        render json: @reward.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      @reward.destroy
      head :no_content
    end
  
    private
  
    def set_reward
      @reward = Reward.find(params[:id])
    end
  
    def reward_params
      params.require(:reward).permit(:transaction_id, :user_card_id, :points_earned, :points_redeemed)
    end
end
class Api::V1::FrontendProfilesController < Api::V1::BaseController
    
      before_action :set_profile, only: [:show, :update]
      skip_before_action :verify_authenticity_token
      
      def show
        render json: @profile
      end

      def update
        if @profile.update(profile_params)
          render json: { message: 'Profile updated successfully', profile: @profile }, status: :ok
        else
          render json: { errors: @profile.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_profile
        @profile = Profile.find_by(users_id: current_user.id)
        render json: { error: 'Profile not found' }, status: :not_found unless @profile
      end

     
      def profile_params
        params.require(:profile).permit(:first_name, :last_name, :date_of_birth, :email, :phone_number, :address, :profile_image)
      end
    
end

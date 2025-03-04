class Api::V1::FrontendUserCardsController < Api::V1::BaseController

   
            # before_action :authenticate_user! # Ensures user is logged in
      
            def index
              # Find the profile of the current logged-in user
              profile = Profile.find_by(users_id: current_user.id)
      
              # If profile exists, fetch associated user_cards where discarded_at is nil
              if profile
                user_cards = UserCard.where(profile_id: profile.id, discarded_at: nil)
                render json: { user_cards: user_cards }, status: :ok
              else
                render json: { error: "Profile not found for the current user" }, status: :not_found
              end
            end
          
   
    
      

end

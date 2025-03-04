class Api::V1::AuthController < Api::V1::BaseController
    
    skip_before_action :authenticate_request, only: :create
    skip_before_action :verify_authenticity_token
    # User login
    def create
      user = User.find_by(email: params[:email])
  
      if user&.valid_password?(params[:password])
        token = jwt_encode(user_id: user.id) # Generate JWT token
        render json: { token: token, user: user }, status: :ok
      else
        render json: { error: 'Invalid credentials' }, status: :unauthorized
      end
    end
  end
  

#   class AuthenticationController < ApplicationController
#     skip_before_action :authenticate_request
#     skip_before_action :verify_authenticity_token

#     def login
#         @user = User.find_by_email(params[:email])
#         if @user&.validate(params[:password])
#             token = jwt_encode(user_id: @user.id)
#             render json: {token: token}, status: :ok
#         else
#             render json: {error:  'unauthorized'}, status: :unauthorized
#         end
#     end
    
# end


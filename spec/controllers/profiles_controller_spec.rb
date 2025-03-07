require 'rails_helper'

RSpec.describe ProfilesController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let(:branch) { create(:branch) }
#   let(:profile) { create(:profile, users_id: user.id, branch_id: branch.id, email: Faker::Internet.unique.email) }
let(:profile) { build_stubbed(:profile, users_id: user.id, branch_id: branch.id) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns only kept profiles' do
      kept_profile = build_stubbed(:profile, users_id: user.id, branch_id: branch.id, email: "rubyonrails")
      discarded_profile = create(:profile, users_id: user.id, branch_id: branch.id, discarded_at: Time.current)
      get :index
      expect(assigns(:profiles)).to include(kept_profile)
      expect(assigns(:profiles)).not_to include(discarded_profile)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: profile.id }
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new profile' do
        expect {
          post :create, params: { profile: attributes_for(:profile, users_id: user.id, branch_id: branch.id) }
        }.to change(Profile, :count).by(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new profile' do
        expect {
          post :create, params: { profile: attributes_for(:profile, first_name: nil) }
        }.not_to change(Profile, :count)
      end
    end
  end

  describe 'PATCH #update' do
    it 'updates the profile' do
      patch :update, params: { id: profile.id, profile: { first_name: 'UpdatedName' } }
      profile.reload
      expect(profile.first_name).to eq('UpdatedName')
    end
  end

  describe 'DELETE #destroy' do
    it 'soft deletes the profile' do
      delete :destroy, params: { id: profile.id }
      profile.reload
      expect(profile.discarded?).to be_truthy
    end
  end
end

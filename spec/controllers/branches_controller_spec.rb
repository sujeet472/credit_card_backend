require 'rails_helper'

RSpec.describe BranchesController, type: :controller do
    include Devise::Test::ControllerHelpers

    let(:user) { create(:user) } 
  let!(:branch) { create(:branch) }

  before do
    sign_in user  # Sign in a user before each test
  end

  

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    context 'when branch exists' do
      it 'returns a successful response' do
        get :show, params: { id: branch.id }
        expect(response).to be_successful
      end
    end

    context 'when branch does not exist' do
      it 'redirects to index with an alert' do
        get :show, params: { id: 'nonexistent' }
        expect(response).to redirect_to(branches_path)
        expect(flash[:alert]).to eq('Branch not found.')
      end
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
      it 'creates a new branch and redirects' do
        expect {
          post :create, params: { branch: attributes_for(:branch) }
        }.to change(Branch, :count).by(1)
        expect(response).to redirect_to(Branch.last)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a branch and renders new' do
        expect {
          post :create, params: { branch: attributes_for(:branch, branch_name: '') }
        }.not_to change(Branch, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #edit' do
    it 'returns a successful response' do
      get :edit, params: { id: branch.id }
      expect(response).to be_successful
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the branch and redirects' do
        patch :update, params: { id: branch.id, branch: { branch_name: 'New Name' } }
        expect(response).to redirect_to(branch)
        expect(branch.reload.branch_name).to eq('New Name')
      end
    end

    context 'with invalid attributes' do
      it 'does not update the branch and renders edit' do
        patch :update, params: { id: branch.id, branch: { branch_name: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(branch.reload.branch_name).not_to eq('')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'soft deletes the branch' do
      expect {
        delete :destroy, params: { id: branch.id }
      }.to change { branch.reload.discarded? }.from(false).to(true)
      expect(response).to redirect_to(branches_path)
    end
  end

  describe 'PATCH #restore' do
    before { branch.discard }
    
    it 'restores the branch' do
      expect {
        patch :restore, params: { id: branch.id }
      }.to change { branch.reload.discarded? }.from(true).to(false)
      expect(response).to redirect_to(branch_path(branch))
    end
  end
end

# require 'rails_helper'

# RSpec.describe BranchesController, type: :controller do
#   let(:valid_attributes) do
#     {
#       branch_name: "Main Branch",
#       branch_address: "123 Street, City",
#       branch_manager: "John Doe",
#       branch_phone: "1234567890",
#       branch_email: "mainbranch@example.com"
#     }
#   end

#   let(:invalid_attributes) do
#     {
#       branch_name: "",
#       branch_address: "",
#       branch_manager: "",
#       branch_phone: "",
#       branch_email: "invalid_email"
#     }
#   end

#   let!(:branch) { Branch.create!(valid_attributes) }

#   describe 'GET #index' do
#     it 'returns a success response' do
#       get :index
#       expect(response).to be_successful
#     end
#   end

#   describe 'GET #show' do
#     it 'returns a success response' do
#       get :show, params: { id: branch.id }
#       expect(response).to be_successful
#     end
#   end

#   describe 'GET #new' do
#     it 'returns a success response' do
#       get :new
#       expect(response).to be_successful
#     end
#   end

#   describe 'POST #create' do
#     context 'with valid attributes' do
#       it 'creates a new Branch' do
#         expect {
#           post :create, params: { branch: valid_attributes }
#         }.to change(Branch, :count).by(1)
#       end

#       it 'redirects to the created branch' do
#         post :create, params: { branch: valid_attributes }
#         expect(response).to redirect_to(assigns(:branch))
#       end
#     end

#     context 'with invalid attributes' do
#       it 'does not create a new Branch' do
#         expect {
#           post :create, params: { branch: invalid_attributes }
#         }.to_not change(Branch, :count)
#       end

#       it 'renders the new template' do
#         post :create, params: { branch: invalid_attributes }
#         expect(response).to render_template(:new)
#       end
#     end
#   end

#   describe 'PATCH/PUT #update' do
#     context 'with valid attributes' do
#       let(:new_attributes) { { branch_name: "Updated Branch" } }

#       it 'updates the branch' do
#         patch :update, params: { id: branch.id, branch: new_attributes }
#         branch.reload
#         expect(branch.branch_name).to eq("Updated Branch")
#       end

#       it 'redirects to the branch' do
#         patch :update, params: { id: branch.id, branch: new_attributes }
#         expect(response).to redirect_to(branch)
#       end
#     end

#     context 'with invalid attributes' do
#       it 'does not update the branch' do
#         patch :update, params: { id: branch.id, branch: invalid_attributes }
#         expect(response).to render_template(:edit)
#       end
#     end
#   end

#   describe 'DELETE #destroy' do
#     it 'soft deletes the branch' do
#       expect {
#         delete :destroy, params: { id: branch.id }
#       }.to change { branch.reload.discarded? }.from(false).to(true)
#     end

#     it 'redirects to branches index' do
#       delete :destroy, params: { id: branch.id }
#       expect(response).to redirect_to(branches_path)
#     end
#   end

#   describe 'POST #restore' do
#     before { branch.discard }

#     it 'restores the branch' do
#       post :restore, params: { id: branch.id }
#       expect(branch.reload.discarded?).to be false
#     end

#     it 'redirects to the branch' do
#       post :restore, params: { id: branch.id }
#       expect(response).to redirect_to(branch_path(branch))
#     end
#   end
# end

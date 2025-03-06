require 'rails_helper'



RSpec.describe User, type: :model do

  describe 'associations' do
    it { should have_one(:profile) }
  end

  describe 'devise modules' do
    it { should respond_to(:email) }
    it { should respond_to(:encrypted_password) }
    it { should respond_to(:reset_password_token) }
    it { should respond_to(:confirmation_token) }
  end

  describe 'database columns' do
    it { should have_db_column(:email).of_type(:string).with_options(null: false, default: "") }
    it { should have_db_column(:encrypted_password).of_type(:string).with_options(null: false, default: "") }
    it { should have_db_column(:reset_password_token).of_type(:string) }
    it { should have_db_column(:confirmation_token).of_type(:string) }
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it "validates email uniqueness case-insensitively" do
        create(:user, email: "test@example.com", password: "password123")
        should validate_uniqueness_of(:email).case_insensitive
      end
      
    it { should validate_presence_of(:password) }
  end

  describe 'callbacks' do
    let(:user) { create(:user) }
    let!(:profile) { create(:profile, user: user) }

    context 'when user is discarded' do
      it 'soft deletes the associated profile' do
        user.discard
        expect(profile.reload.discarded?).to be true
      end
    end

    context 'when user is undiscarded' do
      before { user.discard }
      
      it 'restores the associated profile' do
        user.undiscard
        expect(profile.reload.discarded?).to be false
      end
    end
  end
end
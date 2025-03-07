require 'rails_helper'

RSpec.describe CreditCardsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:user) }
  let!(:credit_card1) { create(:credit_card, type_of_card: 'gold', credit_limit: 5000) }
  let!(:credit_card2) { create(:credit_card, type_of_card: 'silver', credit_limit: 2000, discarded_at: Time.current) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns only non-discarded credit cards' do
      get :index
      expect(assigns(:credit_cards)).to include(credit_card1)
      expect(assigns(:credit_cards)).not_to include(credit_card2)
    end
  end
end

require 'rails_helper'

RSpec.describe Reward, type: :model do
  let(:account_transaction) { create(:account_transaction) }
  let(:user_card) { create(:user_card) }








  describe 'associations' do
    it { should belong_to(:account_transaction) }
    it { should belong_to(:user_card) }
  end

  describe 'validations' do
    it { should validate_presence_of(:account_transaction_id) }
    it { should validate_presence_of(:user_card_id) }
    it { should validate_presence_of(:points_earned) }
    it { should validate_numericality_of(:points_earned).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:points_redeemed) }
    it { should validate_numericality_of(:points_redeemed).is_greater_than_or_equal_to(0) }
  end

  describe 'callbacks' do
    it 'generates reward_id before creation' do
      reward = create(:reward, account_transaction: account_transaction, user_card: user_card)
      expect(reward.id).to match(/^R\d{3}$/)
    end

    it 'updates last_updated when points_earned changes' do
      reward = create(:reward, account_transaction: account_transaction, user_card: user_card, points_earned: 10)
      previous_time = reward.last_updated
      reward.update(points_earned: 20)
      expect(reward.last_updated).not_to eq(previous_time)
    end
  
    it 'updates last_updated when points_redeemed changes' do
      reward = create(:reward, account_transaction: account_transaction, user_card: user_card, points_redeemed: 5)
      previous_time = reward.last_updated
      reward.update(points_redeemed: 10)
      expect(reward.last_updated).not_to eq(previous_time)
    end
  end

  describe 'soft deletion' do
    it 'can be discarded and restored' do
      reward = create(:reward, account_transaction: account_transaction, user_card: user_card)
      reward.discard
      expect(reward.discarded?).to be true
      reward.undiscard
      expect(reward.discarded?).to be false
    end
  end
end

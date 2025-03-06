require 'rails_helper'

RSpec.describe UserCard, type: :model do


  describe 'associations' do
    it { should belong_to(:credit_card) }
    it { should belong_to(:profile) }
    it { should have_many(:rewards) }
    it { should have_many(:account_transactions) }
    it { should have_many(:merchant_transactions).class_name('AccountTransaction').with_foreign_key('merchant_id') }
  end

  describe 'validations' do
    it { should validate_presence_of(:credit_card_id) }
    it { should validate_presence_of(:profile_id) }
    it { should validate_presence_of(:issue_date) }
    it { should validate_presence_of(:expiry_date) }
    it { should validate_numericality_of(:cvv).only_integer.is_greater_than_or_equal_to(100).is_less_than_or_equal_to(999).on(:create) }
    # it { should validate_inclusion_of(:is_active).in_array([true, false]) }
    it { should validate_numericality_of(:available_limit).is_greater_than_or_equal_to(0) }
  end

  describe 'callbacks' do
    let(:user_card) { build(:user_card, cvv: '123') }

    it 'hashes the CVV before validation' do
      expect(user_card).to receive(:hash_cvv)
      user_card.valid?
    end

    let(:credit_card) { create(:credit_card) }
  let(:profile) { create(:profile) }
  let(:user_card) { build(:user_card, credit_card: credit_card, profile: profile, cvv: '123') }

  it 'generates a unique user_card_id before create' do
    allow(UserCard).to receive(:lock).and_return(UserCard)
    allow(UserCard).to receive(:where).and_return(UserCard)
    allow(UserCard).to receive(:order).and_return([build(:user_card, id: 'UC001')])
    
    user_card.save!  
    expect(user_card.id).to match(/^UC\d{3}$/)
  end
  end

  describe 'discard behavior' do
    let!(:user_card) { create(:user_card) }
    let!(:reward) { create(:reward, user_card: user_card) }
    let!(:transaction) { create(:account_transaction, user_card: user_card) }

    it 'soft deletes associated rewards and transactions when discarded' do
      user_card.discard
      expect(reward.reload.discarded?).to be_truthy
      expect(transaction.reload.discarded?).to be_truthy
    end

    it 'restores associated rewards and transactions when undiscarded' do
      user_card.discard
      user_card.undiscard
      expect(reward.reload.discarded?).to be_falsey
      expect(transaction.reload.discarded?).to be_falsey
    end
  end
end

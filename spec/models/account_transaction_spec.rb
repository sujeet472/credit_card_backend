require 'rails_helper'

RSpec.describe AccountTransaction, type: :model do
  let(:payer) { create(:user_card, available_limit: 1000) }
  let(:payee) { create(:user_card) }
  let(:valid_attributes) do
    {
      user_card: payer,
      merchant: payee,
      transaction_date: Time.current,
      amount: 100.0,
      transaction_type: 'purchase'
    }
  end

  describe 'validations' do
    it { should validate_presence_of(:user_card_id) }
    it { should validate_presence_of(:transaction_date) }
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:merchant_id) }
    it { should validate_presence_of(:transaction_type) }
    it { should validate_inclusion_of(:transaction_type).in_array(['purchase', 'refund', 'adjustment']) }
  end

  describe 'associations' do
    it { should belong_to(:user_card) }
    it { should belong_to(:merchant).class_name('UserCard') }
    it { should have_one(:reward).dependent(:destroy) }
  end

  describe 'callbacks' do
    it 'generates a unique transaction ID before create' do
      transaction = AccountTransaction.create!(valid_attributes)
      expect(transaction.id).to match(/^T\d{3}$/)
    end

    it 'deducts available limit after create' do
      expect { AccountTransaction.create!(valid_attributes) }
        .to change { payer.reload.available_limit }.by(-100.0)
        .and change { payee.reload.available_limit }.by(100.0)
    end

    it 'restores available limit when discarded' do
      transaction = AccountTransaction.create!(valid_attributes)
      expect { transaction.discard }
        .to change { payer.reload.available_limit }.by(100.0)
        .and change { payee.reload.available_limit }.by(-100.0)
    end

    it 'creates a reward if eligible' do
      transaction = AccountTransaction.create!(valid_attributes)
      expect(transaction.reward).to be_present
      expect(transaction.reward.points_earned).to eq(1) # 1% of 100
    end
  end

  describe 'business logic' do
    it 'prevents transaction if funds are insufficient' do
      payer.update!(available_limit: 50)
      transaction = AccountTransaction.new(valid_attributes.merge(amount: 100))
      expect(transaction).not_to be_valid
      expect(transaction.errors[:base]).to include('Insufficient funds to complete the transaction')
    end

    it 'refunds correctly by reversing balances' do
      purchase = AccountTransaction.create!(valid_attributes)
      refund = AccountTransaction.create!(valid_attributes.merge(transaction_type: 'refund'))
      expect(payer.reload.available_limit).to eq(1000)
      expect(payee.reload.available_limit).to eq(0)
    end
  end
end

require 'rails_helper'

RSpec.describe AccountTransaction, type: :model do
  let!(:user_profile) { create(:profile, email: "user1@example.com") }
let!(:merchant_profile) { create(:profile, email: "user2@example.com") }



  



  describe "Validations" do
    it { should validate_presence_of(:user_card_id) }
    it { should validate_presence_of(:transaction_date) }
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
    it { should validate_presence_of(:merchant_id) }
    it { should validate_presence_of(:transaction_type) }
    it { should validate_inclusion_of(:transaction_type).in_array(['purchase', 'refund', 'adjustment']) }
  end

  describe "Associations" do
    it { should belong_to(:user_card) }
    it { should belong_to(:merchant).class_name('UserCard') }
    it { should have_one(:reward).dependent(:destroy) }
  end

  describe "Callbacks" do
    it "generates an ID before creation" do
      transaction = create(:account_transaction, user_card: user_card, merchant: merchant, amount: 100.00)
      expect(transaction.id).to match(/T\d{3}/) # Format: T001, T002, etc.
    end

    it "checks sufficient balance before creating a purchase" do
      transaction = build(:account_transaction, user_card: user_card, merchant: merchant, amount: 6000.00)
      expect(transaction).to be_invalid
      expect(transaction.errors[:base]).to include("Insufficient funds to complete the transaction")
    end
  end

  describe "Business Logic" do
    it "deducts available limit after purchase" do
      transaction = create(:account_transaction, user_card: user_card, merchant: merchant, amount: 1000.00)
      user_card.reload
      expect(user_card.available_limit).to eq(4000.00)
    end

    it "restores available limit on refund" do
      transaction = create(:account_transaction, user_card: user_card, merchant: merchant, amount: 1000.00, transaction_type: 'refund')
      user_card.reload
      expect(user_card.available_limit).to eq(6000.00)
    end
  end

  describe "Soft Delete" do
    let!(:transaction) { create(:account_transaction, user_card: user_card, merchant: merchant, amount: 500.00) }

    it "discards transaction and restores available limit" do
      transaction.discard
      user_card.reload
      expect(transaction.discarded?).to be true
      expect(user_card.available_limit).to eq(5500.00)
    end

    it "undiscards transaction and deducts available limit" do
      transaction.discard
      transaction.undiscard
      user_card.reload
      expect(transaction.discarded?).to be false
      expect(user_card.available_limit).to eq(4500.00)
    end
  end
end

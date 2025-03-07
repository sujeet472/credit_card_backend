
require 'rails_helper'

RSpec.describe AccountTransaction, type: :model do
  
  let(:user_profile) { create(:profile, email: "reactdemo@gmail.com") }
  let(:merchant_profile) { create(:profile, email: "railsrr@gmail.com") }

  let(:user_card) { create(:user_card, profile: user_profile, available_limit: 1000.00) }
  let(:merchant_card) { create(:user_card, profile: merchant_profile, available_limit: 500.00) }


  describe 'associations' do
    it { should belong_to(:user_card) }
    it { should belong_to(:merchant).class_name('UserCard') }
    it { should have_one(:reward).dependent(:destroy) }
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

end















# require 'rails_helper'

# RSpec.describe AccountTransaction, type: :model do
  
#   let(:user_profile) { create(:profile, email: "reactdemo@gmail.com") }
#   let(:merchant_profile) { create(:profile, email: "railsrr@gmail.com") }

#   let(:user_card) { create(:user_card, profile: user_profile, available_limit: 1000.00) }
#   let(:merchant_card) { create(:user_card, profile: merchant_profile, available_limit: 500.00) }


#   describe 'associations' do
#     it { should belong_to(:user_card) }
#     it { should belong_to(:merchant).class_name('UserCard') }
#     it { should have_one(:reward).dependent(:destroy) }
#   end

#   describe 'validations' do
#     it { should validate_presence_of(:user_card_id) }
#     it { should validate_presence_of(:transaction_date) }
#     it { should validate_presence_of(:amount) }
#     it { should validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
#     it { should validate_presence_of(:merchant_id) }
#     it { should validate_presence_of(:transaction_type) }
#     it { should validate_inclusion_of(:transaction_type).in_array(['purchase', 'refund', 'adjustment']) }
#   end

#   describe 'callbacks' do
#     # it 'generates an account transaction ID before creation' do
#     #   transaction = create(:account_transaction, user_card: user_card, merchant: merchant_card)
#     #   transaction.save!
#     #   expect(transaction.id).to match(/T\d{3}/)
#     # end

#     # it 'checks sufficient balance before creation' do
#     #   transaction = create(:account_transaction, user_card: user_card, merchant: merchant_card, amount: 1500)
#     #   expect(transaction.save).to be_falsey
#     #   expect(transaction.errors[:base]).to include('Insufficient funds to complete the transaction')
#     # end
#   end

#   describe 'soft deletion (discard gem)' do
#     # it 'soft deletes an account transaction' do
#     #   transaction = create(:account_transaction, user_card: user_card, merchant: merchant_card)
#     #   expect { transaction.discard }.to change { transaction.discarded? }.from(false).to(true)
#     # end

#     # it 'restores a discarded transaction' do
#     #   transaction = create(:account_transaction, user_card: user_card, merchant: merchant_card)
#     #   transaction.discard
#     #   expect { transaction.undiscard }.to change { transaction.discarded? }.from(true).to(false)
#     # end
#   end

#   describe 'available limit updates' do
#     # it 'deducts available limit for a purchase' do
#     #   transaction = create(:account_transaction, user_card: user_card, merchant: merchant_card, amount: 100, transaction_type: 'purchase')
#     #   user_card.reload
#     #   merchant_card.reload
#     #   expect(user_card.available_limit).to eq(900.00)
#     #   expect(merchant_card.available_limit).to eq(600.00)
#     # end

#     # it 'restores available limit for a refund' do
#     #   transaction = create(:account_transaction, user_card: user_card, merchant: merchant_card, amount: 100, transaction_type: 'refund')
#     #   user_card.reload
#     #   merchant_card.reload
#     #   expect(user_card.available_limit).to eq(1100.00)
#     #   expect(merchant_card.available_limit).to eq(400.00)
#     # end
#   end

#   # describe 'reward points' do
#   #   it 'creates a reward if eligible' do
#   #     transaction = create(:account_transaction, user_card: user_card, merchant: merchant_card, amount: 100, transaction_type: 'purchase')
#   #     expect(transaction.reward).to be_present
#   #     expect(transaction.reward.points_earned).to eq(1) # 1% of 100
#   #   end
#   # end
# end
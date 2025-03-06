require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:type_of_card) }
    it { should validate_inclusion_of(:type_of_card).in_array(%w[silver gold platinum]).with_message(/is not a valid card type/) }


    it { should validate_presence_of(:credit_limit) }
    it { should validate_numericality_of(:credit_limit).is_greater_than_or_equal_to(0) }
  end

  describe 'associations' do
    it { should have_many(:user_cards) }
  end

  describe 'ID generation' do
    it 'generates a custom credit card ID' do
      credit_card = create(:credit_card)  # Create a new credit card
      expect(credit_card.id).to match(/^CC\d{3}$/)  # Ensure format is CC001, CC002, etc.
    end

    it 'increments ID correctly' do
      create(:credit_card, id: 'CC001')
      new_card = create(:credit_card)  # This should be CC002
      expect(new_card.id).to eq('CC002')
    end
  end

  describe 'soft delete (discard) functionality' do
    let(:credit_card) { create(:credit_card) }

    it 'soft deletes a credit card' do
      expect(credit_card.discarded?).to be false
      credit_card.discard
      expect(credit_card.discarded?).to be true
    end

    it 'restores a soft-deleted credit card' do
      credit_card.discard
      expect(credit_card.discarded?).to be true
      credit_card.undiscard
      expect(credit_card.discarded?).to be false
    end

    it 'discards associated user_cards when discarding credit card' do
      user_card = create(:user_card, credit_card: credit_card)
      expect(user_card.discarded?).to be false

      credit_card.discard
      user_card.reload
      expect(user_card.discarded?).to be true
    end

    it 'restores associated user_cards when undiscarding credit card' do
      user_card = create(:user_card, credit_card: credit_card)
      credit_card.discard
      credit_card.undiscard
      user_card.reload
      expect(user_card.discarded?).to be false
    end
  end
end

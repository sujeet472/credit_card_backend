require 'rails_helper'

RSpec.describe Branch, type: :model do
  describe 'validations' do
    let!(:existing_branch) { create(:branch, branch_name: "Main Branch", branch_address: "123 Main St", branch_manager: "John Doe", branch_phone: "1234567890", branch_email: "test@example.com") }

    let(:valid_branch) { build(:branch, branch_name: "Test", branch_address: "123 Street", branch_manager: "Manager", branch_email: "test@example.com", branch_phone: "1234567890") }

    it "validates presence of branch_phone" do
        branch = Branch.new(branch_phone: "")
        branch.valid?
        expect(branch.errors[:branch_phone]).to include("can't be blank")
      end
      



    it { should validate_presence_of(:branch_name) }
    it { should validate_length_of(:branch_name).is_at_most(50) }

    it { should validate_presence_of(:branch_address) }

    it { should validate_presence_of(:branch_manager) }
    it { should validate_length_of(:branch_manager).is_at_most(50) }

    it { should validate_presence_of(:branch_phone) }
    it { should validate_uniqueness_of(:branch_phone).case_insensitive }
    it { should validate_length_of(:branch_phone).is_at_most(15) }

    it { should validate_presence_of(:branch_email) }
    let!(:existing_branch) { create(:branch, branch_email: "test@example.com") }

it "validates uniqueness of branch_email" do
  new_branch = Branch.new(branch_email: "test@example.com")
  new_branch.valid?
  expect(new_branch.errors[:branch_email]).to include("has already been taken")
end

    it { should validate_length_of(:branch_email).is_at_most(100) }

    let!(:existing_branch) { create(:branch, branch_email: 'test@example.com') }


    it { should allow_value('unique@example.com').for(:branch_email) }
    it { should_not allow_value('invalid_email').for(:branch_email) }
  end

  describe 'associations' do
    it { should have_many(:profiles) }
  end

  describe 'discard and restore' do
    let(:branch) { create(:branch) }

    it 'discards the branch and associated profiles' do
      expect(branch.discarded?).to be false
      branch.discard
      expect(branch.discarded?).to be true
    end

    it 'restores the branch and associated profiles' do
      branch.discard
      expect(branch.discarded?).to be true
      branch.undiscard
      expect(branch.discarded?).to be false
    end
  end
end

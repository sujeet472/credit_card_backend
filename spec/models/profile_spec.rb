require 'rails_helper'

RSpec.describe Profile, type: :model do
  let!(:branch) { create(:branch) }
  let!(:user) { create(:user) }
  let!(:profile) { build(:profile, branch: branch, user: user) }

  describe "Validations" do
    it "is valid with valid attributes" do
      expect(profile).to be_valid
    end

    it "validates presence of first_name" do
      profile.first_name = nil
      expect(profile).not_to be_valid
    end

    it "validates presence of last_name" do
      profile.last_name = nil
      expect(profile).not_to be_valid
    end

    it "validates presence of email" do
      profile.email = nil
      expect(profile).not_to be_valid
    end

    it "validates presence of phone_number" do
      profile.phone_number = nil
      expect(profile).not_to be_valid
    end

    it "validates presence of address" do
      profile.address = nil
      expect(profile).not_to be_valid
    end

    it "validates presence of account_type" do
      profile.account_type = nil
      expect(profile).not_to be_valid
    end

    it "validates association with a branch" do
      profile.branch = nil
      expect(profile).not_to be_valid
    end

    it "validates association with a user" do
      profile.user = nil
      expect(profile).not_to be_valid
    end

    it "allows valid account types" do
      valid_account_types = ["saving", "current", "salary"]
      valid_account_types.each do |account_type|
        profile.account_type = account_type
        expect(profile).to be_valid
      end
    end
  end

  describe "Callbacks" do
    it "assigns a formatted id before creation" do
      profile.save!
      expect(profile.id).to match(/^P\d{3}$/) # Should be like P001, P002
    end
  end

  describe "Soft Delete" do
    let!(:credit_card) { create(:credit_card) }
  
    before do
      profile.save!
      @user_card = profile.user_cards.create!(
        id: "UC001",
        cvv: "123",
        credit_card: credit_card, # Associate the user_card with a valid credit_card
        issue_date: "2021-01-01",
        expiry_date: "2023-01-01",
        available_limit: 1000.00
      )
    end
  
    it "soft deletes profile and associated user_cards" do
      profile.discard
      expect(profile.discarded?).to be true
      expect(@user_card.reload.discarded?).to be true
    end
  
    it "restores profile and associated user_cards" do
      profile.discard
      profile.undiscard
      expect(profile.discarded?).to be false
      expect(@user_card.reload.discarded?).to be false
    end
  end
  
end













# require 'rails_helper'

# RSpec.describe Profile, type: :model do
#   let(:branch) { Branch.create(id: "B001", branch_name: "Main Branch") }
#   let(:user) { User.create(id: 1, email: "john@example.com", password: "password123") }

#   subject {
#     described_class.new(
#       first_name: "John",
#       last_name: "Doe",
#       date_of_birth: "1990-01-01",
#       email: "john.doe@example.com",
#       phone_number: 1234567890,
#       address: "123 Main Street, City",
#       branch_id: branch.id,
#       profile_image: "profile.jpg",
#       account_type: "saving",
#       users_id: user.id
#     )
#   }

#   describe "Validations" do
#     it "is valid with valid attributes" do
#       expect(subject).to be_valid
#     end

#     it "is not valid without a first_name" do
#       subject.first_name = nil
#       expect(subject).to_not be_valid
#     end

#     it "is not valid without a last_name" do
#       subject.last_name = nil
#       expect(subject).to_not be_valid
#     end

#     it "is not valid without a date_of_birth" do
#       subject.date_of_birth = nil
#       expect(subject).to_not be_valid
#     end

#     it "is not valid without an email" do
#       subject.email = nil
#       expect(subject).to_not be_valid
#     end

#     it "is not valid with a duplicate email" do
#       subject.save
#       duplicate_profile = subject.dup
#       duplicate_profile.email = subject.email.upcase # Checking case-insensitivity
#       expect(duplicate_profile).to_not be_valid
#     end

#     it "is not valid without a phone_number" do
#       subject.phone_number = nil
#       expect(subject).to_not be_valid
#     end

#     it "is not valid with a duplicate phone_number" do
#       subject.save
#       duplicate_profile = subject.dup
#       duplicate_profile.phone_number = subject.phone_number
#       expect(duplicate_profile).to_not be_valid
#     end

#     it "is not valid without an address" do
#       subject.address = nil
#       expect(subject).to_not be_valid
#     end

#     it "is not valid without a branch_id" do
#       subject.branch_id = nil
#       expect(subject).to_not be_valid
#     end

#     it "is not valid with an invalid account_type" do
#       subject.account_type = "investment"
#       expect(subject).to_not be_valid
#     end

#     it "allows valid account types" do
#       %w[saving current salary].each do |valid_type|
#         subject.account_type = valid_type
#         expect(subject).to be_valid
#       end
#     end
#   end

#   describe "Associations" do
#     it { should belong_to(:branch) }
#     it { should belong_to(:user).with_foreign_key('users_id') }
#     it { should have_many(:user_cards) }
#   end

#   describe "Callbacks" do
#     it "assigns a formatted id before creation" do
#       subject.save
#       expect(subject.id).to match(/^P\d{3}$/) # Should be like P001, P002
#     end

#     it "soft deletes profile and associated user_cards" do
#       subject.save
#       user_card = subject.user_cards.create(id: "UC001", card_number: "1234-5678-9012-3456")
      
#       expect(subject.discarded?).to be false
#       subject.discard
#       expect(subject.discarded?).to be true
#       expect(user_card.reload.discarded?).to be true
#     end

#     it "restores profile and associated user_cards" do
#       subject.save
#       user_card = subject.user_cards.create(id: "UC001", card_number: "1234-5678-9012-3456")
      
#       subject.discard
#       expect(subject.discarded?).to be true
      
#       subject.undiscard
#       expect(subject.discarded?).to be false
#       expect(user_card.reload.discarded?).to be false
#     end
#   end
# end

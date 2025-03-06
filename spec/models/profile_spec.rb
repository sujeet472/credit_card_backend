
# require 'rails_helper'

# RSpec.describe Profile, type: :model do
#   let!(:branch) { create(:branch) }
#   let!(:profile) { create(:profile, branch: branch) }

#   describe 'associations' do
#     it { should belong_to(:branch) }
#     it { should belong_to(:user).class_name('User').with_foreign_key('users_id') }
#     it { should have_many(:user_cards)}
#   end

#   describe 'validations' do
#     it { should validate_presence_of(:first_name) }
#     it { should validate_length_of(:first_name).is_at_most(50) }

#     it { should validate_presence_of(:last_name) }
#     it { should validate_length_of(:last_name).is_at_most(50) }

#     it { should validate_presence_of(:date_of_birth) }

#     it { should validate_presence_of(:email) }
#     it { should validate_length_of(:email).is_at_most(100) }
#     it { should validate_uniqueness_of(:email).case_insensitive }
#     it { should allow_value('test@example.com').for(:email) }
#     it { should_not allow_value('invalid_email').for(:email) }

#     it { should validate_presence_of(:phone_number) }
#     it { should validate_uniqueness_of(:phone_number) }
#     # it { should validate_length_of(:phone_number).is_at_most(15) }

#     it { should validate_presence_of(:address) }

#     it { should validate_length_of(:profile_image).is_at_most(255).allow_nil }

#     it { should validate_inclusion_of(:account_type).in_array(%w[saving current salary]).with_message(/is not a valid account type/) }
#   end

#   describe 'callbacks' do
#     let!(:profile) { create(:profile) }
#     let!(:user_card) { create(:user_card, profile: profile) }

#     it 'soft deletes associated user_cards when discarded' do
#       profile.discard
#       expect(user_card.reload.discarded?).to be_truthy
#     end

#     it 'restores associated user_cards when undiscarded' do
#       profile.discard
#       profile.undiscard
#       expect(user_card.reload.discarded?).to be_falsey
#     end
#   end

#   describe 'ID generation' do
#     it 'generates a unique profile ID before creation' do
#       profile = build(:profile, email:"newemail1@gmail.com")
#       expect(profile.id).to match(/^P\d{3}$/)
#     end

#     # it 'increments profile ID correctly' do
#     #     first_profile = create(:profile)  
#     #     second_profile = create(:profile)
        
#     #     expected_id = "P#{(first_profile.id[1..-1].to_i + 1).to_s.rjust(3, '0')}"
        
#     #     expect(second_profile.id).to eq(expected_id)
#     #   end
      
      
#   end
# end

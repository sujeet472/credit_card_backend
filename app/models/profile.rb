class Profile < ApplicationRecord
  include Discard::Model
  
    belongs_to :branch
    has_many :user_cards
    # belongs_to :user, foreign_key: 'users_id'
    # has_many :merchant_transactions, class_name: "AccountTransaction", foreign_key: "merchant_id"
    belongs_to :user, class_name: "User", foreign_key: "users_id"
  
    validates :first_name, presence: true, length: { maximum: 50 }
    validates :last_name, presence: true, length: { maximum: 50 }
    validates :date_of_birth, presence: true
    validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 100 }, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :phone_number, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 15 }
    validates :address, presence: true
    validates :profile_image, length: { maximum: 255 }, allow_nil: true
    validates :account_type, inclusion: { in: %w[saving current salary], message: "%{value} is not a valid account type" }
    validates :branch_id, presence: true

    before_discard do
     
      user_cards.discard_all
    end

    after_undiscard do
     
      user_cards.undiscard_all
    end

    before_create :generate_profile_id
   
    private
  
    def generate_profile_id
     
        last_id = Profile.maximum(:id)
        next_number = last_id.present? ? last_id.gsub(/\D/, '').to_i + 1 : 1  # Extract number and increment
        self.id = "P#{next_number.to_s.rjust(3, '0')}"  # Format as CC001, CC002, etc.
      
    end

    # def generate_profile_id
    #   # Get the next available reward number
    #   last_id = Profile.order(:id).last&.id
    #   next_number = last_id ? last_id[1..-1].to_i + 1 : 1 # Start from 1 if there are no records
  
    #   # Format the reward_id as R00(x), where (x) is the next number
    #   self.id = "P#{next_number.to_s.rjust(3, '0')}"
    # end
  end
  
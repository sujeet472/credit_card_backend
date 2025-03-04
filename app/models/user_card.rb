class UserCard < ApplicationRecord
  include Discard::Model
  
    belongs_to :credit_card
    belongs_to :profile
    has_many :rewards
    has_many :account_transactions
    has_many :merchant_transactions, class_name: "AccountTransaction", foreign_key: "merchant_id"

    validates :credit_card_id, presence: true
    validates :profile_id, presence: true
    validates :issue_date, presence: true
    validates :expiry_date, presence: true
    validates :cvv, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 100, less_than_or_equal_to: 999 }, on: :create
    validates :is_active, inclusion: { in: [true, false] }
    validates :available_limit, presence: true, numericality: { greater_than_or_equal_to: 0 }
  

    before_discard do
      rewards.discard_all
      account_transactions.discard_all
    end

    after_undiscard do
      rewards.undiscard_all
      account_transactions.undiscard_all
    end


    # Virtual attribute to handle CVV input
    attr_accessor :cvv

    # Automatically generate user_card_id in the format UC00x
    before_validation :hash_cvv
    before_create :generate_user_card_id
    # before_save :hash_cvv
  
    private

    def generate_user_card_id
      last_card = UserCard.lock("FOR UPDATE").where("id LIKE 'UC%'")
                          .order(Arel.sql("CAST(SUBSTR(id, 3) AS INTEGER) DESC"))
                          .first
      next_number = last_card ? last_card.id[2..].to_i + 1 : 1
      self.id = "UC#{next_number.to_s.rjust(3, '0')}"
    end
    

    def hash_cvv
      puts "Hashing CVV..."
      if cvv.present?
        self.hashed_cvv = BCrypt::Password.create(cvv)
      end
    end
    


end

  
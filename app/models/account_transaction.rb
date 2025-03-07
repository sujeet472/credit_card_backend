class AccountTransaction < ApplicationRecord
  include Discard::Model

  belongs_to :user_card
  # belongs_to :merchant, class_name: "Customer", foreign_key: "merchant_id"
  belongs_to :merchant, class_name: "UserCard", foreign_key: "merchant_id"

  has_one :reward, dependent: :destroy

  validates :user_card_id, presence: true
  validates :transaction_date, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :merchant_id, presence: true
  validates :transaction_type, presence: true, inclusion: { in: ['purchase', 'refund', 'adjustment'] }

  before_discard :restore_available_limit, :restore_reward_points
  after_discard :discard_rewards

  after_undiscard :deduct_available_limit, :deduct_reward_points
  after_undiscard :undiscard_rewards

  before_create :generate_account_transaction_id, :check_sufficient_balance
  after_create :create_reward_if_eligible, :update_available_limit

  private

  def generate_account_transaction_id
    last_id = AccountTransaction.order(:id).last&.id
    next_number = last_id ? last_id[1..-1].to_i + 1 : 1
    self.id = "T#{next_number.to_s.rjust(3, '0')}"
  end


  def check_sufficient_balance
    return if transaction_type == 'refund'
  
    payer = UserCard.kept.find_by(id: user_card_id)
    unless payer
      errors.add(:base, "UserCard not found or is inactive")
      throw(:abort)
    end
  
    if payer.available_limit < amount
      errors.add(:base, "Insufficient funds to complete the transaction")
      throw(:abort)
    end
  end

  def update_available_limit
    payer = UserCard.kept.find_by(id: user_card_id) 
    payee = UserCard.kept.find_by(id: merchant_id) # The recipient 
    
    return unless payer && payee
  
    if transaction_type == 'refund'
      # If it's a refund, reverse the transaction (add amount to payer, deduct from payee)
      payer.update!(available_limit: payer.available_limit + amount)
      payee.update!(available_limit: payee.available_limit - amount)
    else
      # For a purchase/adjustment, deduct from payer and credit to payee
      payer.update!(available_limit: payer.available_limit - amount)
      payee.update!(available_limit: payee.available_limit + amount)
    end
  rescue StandardError => e
    Rails.logger.error "Error updating available limits for transaction: #{e.message}"
    raise ActiveRecord::Rollback
  end
  


  def check_sufficient_balance
    return if transaction_type == 'refund'
    user_card = UserCard.kept.find_by(id: user_card_id)
    unless user_card
      errors.add(:base, "UserCard not found or is inactive")
      throw(:abort)
    end

    if user_card.available_limit < amount
      errors.add(:base, "Insufficient funds to complete the transaction")
      throw(:abort)
    end
  end    

  def restore_available_limit
    user_card = UserCard.kept.find_by(id: user_card_id)
    return unless user_card

    if transaction_type == 'refund'
      # If refund is then decrease available limit
      user_card.update!(available_limit: user_card.available_limit - amount)
    else
      # If purchase or adjustment is discarded, increase available limit
      user_card.update!(available_limit: user_card.available_limit + amount)
    end
  rescue StandardError => e
    Rails.logger.error "Error restoring available limit: #{e.message}"
  end

  def deduct_available_limit
    user_card = UserCard.kept.find_by(id: user_card_id)
    return unless user_card

    if transaction_type == 'refund'
      # If refund is undiscarded, increase available limit
      user_card.update!(available_limit: user_card.available_limit + amount)
    else
      # If purchase/adjustment is undiscarded, decrease available limit
      user_card.update!(available_limit: user_card.available_limit - amount)
    end
  rescue StandardError => e
    Rails.logger.error "Error deducting available limit: #{e.message}"
  end

  def restore_reward_points
    return unless transaction_type == 'refund' && reward.present?

    # Restore deducted reward points when refund is discarded
    reward.update!(points_earned: reward.points_earned + calculate_reward_points(amount))
  rescue StandardError => e
    Rails.logger.error "Error restoring reward points: #{e.message}"
  end

  def deduct_reward_points
    return unless transaction_type == 'refund' && reward.present?

    # Deduct reward points again when refund is undiscarded
    reward.update!(points_earned: [reward.points_earned - calculate_reward_points(amount), 0].max)
  rescue StandardError => e
    Rails.logger.error "Error deducting reward points: #{e.message}"
  end

  def discard_rewards
    reward.discard if reward.present?
  end

  def undiscard_rewards
    reward.undiscard if reward.present?
  end

  def create_reward_if_eligible
    return unless transaction_type == 'purchase'
    points_earned = calculate_reward_points(amount)

    Reward.create!(
      account_transaction_id: id,
      user_card_id: user_card_id,
      points_earned: points_earned,
      points_redeemed: 0
    )
  end

  def calculate_reward_points(amount)
    (amount * 0.01).to_i
  end
end


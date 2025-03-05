class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    # Key metrics for cards at the top
    @total_profiles = Profile.where(discarded_at: nil).count
    @active_cards = UserCard.where(is_active: true, discarded_at: nil).count
    @total_transactions = AccountTransaction.where(discarded_at: nil).count
    @total_branches = Branch.where(discarded_at: nil).count
    
    @monthly_transactions = AccountTransaction.where(discarded_at: nil)
                        .where('transaction_date >= ?', 6.months.ago)
                        .group("strftime('%Y-%m', transaction_date)")
                        .count

    
    # For recent transactions table
    @recent_transactions = AccountTransaction.includes(user_card: :profile)
                          .where(discarded_at: nil)
                          .order(transaction_date: :desc)
                          .limit(10)
    
    # For card type distribution
    @card_distribution = CreditCard.joins(:user_cards)
                        .where(user_cards: { is_active: true, discarded_at: nil })
                        .group(:type_of_card)
                        .count
  end
end
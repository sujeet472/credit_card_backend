# app/controllers/dashboard_controller.rb
class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    # Summary statistics
    @total_profiles = Profile.where(discarded_at: nil).count
    @active_cards = UserCard.where(is_active: true, discarded_at: nil).count
    @total_transactions = AccountTransaction.where(discarded_at: nil).count
    @total_branches = Branch.where(discarded_at: nil).count
    
    @monthly_transactions = AccountTransaction.where(discarded_at: nil)
    .where('transaction_date >= ?', 6.months.ago)
    .group("strftime('%Y-%m', transaction_date)")
    .count

# Transaction amounts by month for the line graph
@monthly_transaction_amounts = AccountTransaction.where(discarded_at: nil)
           .where('transaction_date >= ?', 6.months.ago)
           .group("strftime('%Y-%m', transaction_date)")
           .sum(:amount)
    
    # Recent transactions for the table
    @recent_transactions = AccountTransaction.includes(user_card: :profile)
                          .where(discarded_at: nil)
                          .order(transaction_date: :desc)
                          .limit(10)
    
    # Card type distribution for pie chart
    @card_distribution = CreditCard.joins(:user_cards)
                        .where(user_cards: { is_active: true, discarded_at: nil })
                        .group(:type_of_card)
                        .count
    
    # Top merchants by transaction volume
    @top_merchants = AccountTransaction.where(discarded_at: nil)
                  .select("merchant_id, COUNT(*) as transaction_count")
                  .group(:merchant_id)
                  .order(Arel.sql("transaction_count DESC"))
                  .limit(5)

    
    # User activity - new profiles by month
    @new_profiles_by_month = Profile.where(discarded_at: nil)
                       .where('created_at >= ?', 6.months.ago)
                       .group("strftime('%Y-%m', created_at)")
                       .count
    
    # Credit utilization calculation
    @credit_utilization = calculate_credit_utilization
  end
  
  private
  
  def calculate_credit_utilization
    active_cards = UserCard.where(is_active: true, discarded_at: nil)
    total_limit = active_cards.sum(:available_limit)
    
    if total_limit > 0
      used_credit = CreditCard.joins(:user_cards)
                   .where(user_cards: { is_active: true, discarded_at: nil })
                   .sum('credit_limit - user_cards.available_limit')
      
      ((used_credit / total_limit) * 100).round(2)
    else
      0
    end
  end
end
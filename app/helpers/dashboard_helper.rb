# app/helpers/dashboard_helper.rb
module DashboardHelper
    def get_category_color(category)
      case category
      when 'purchase'
        '#2ecc71' # green
      when 'refund'
        '#e74c3c' # red
      when 'payment'
        '#3498db' # blue
      when 'fee'
        '#f39c12' # orange
      when 'interest'
        '#9b59b6' # purple
      when 'transfer'
        '#1abc9c' # turquoise
      else
        '#34495e' # dark blue
      end
    end
  end
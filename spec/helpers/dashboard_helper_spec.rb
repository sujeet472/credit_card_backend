require 'rails_helper'

RSpec.describe DashboardHelper, type: :helper do
  describe '#get_category_color' do
    it 'returns green (#2ecc71) for purchase category' do
      expect(helper.get_category_color('purchase')).to eq('#2ecc71')
    end

    it 'returns red (#e74c3c) for refund category' do
      expect(helper.get_category_color('refund')).to eq('#e74c3c')
    end

    it 'returns blue (#3498db) for payment category' do
      expect(helper.get_category_color('payment')).to eq('#3498db')
    end

    it 'returns orange (#f39c12) for fee category' do
      expect(helper.get_category_color('fee')).to eq('#f39c12')
    end

    it 'returns purple (#9b59b6) for interest category' do
      expect(helper.get_category_color('interest')).to eq('#9b59b6')
    end

    it 'returns turquoise (#1abc9c) for transfer category' do
      expect(helper.get_category_color('transfer')).to eq('#1abc9c')
    end

    it 'returns dark blue (#34495e) for an unknown category' do
      expect(helper.get_category_color('unknown')).to eq('#34495e')
    end

    it 'returns dark blue (#34495e) for a nil category' do
      expect(helper.get_category_color(nil)).to eq('#34495e')
    end

    it 'returns dark blue (#34495e) for an empty string' do
      expect(helper.get_category_color('')).to eq('#34495e')
    end
  end
end

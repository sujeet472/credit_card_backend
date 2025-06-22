require "test_helper"

class CreditCardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)   # assuming you have a users fixture
    sign_in @user
  end
  
  test "should get index" do
    get credit_cards_url
    assert_response :success
  end
end

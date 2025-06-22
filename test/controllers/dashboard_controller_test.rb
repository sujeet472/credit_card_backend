require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)  # assuming your fixture is named `one` in users.yml
    sign_in @user
  end

  test "should get index" do
    get dashboard_url
    assert_response :success
  end
end
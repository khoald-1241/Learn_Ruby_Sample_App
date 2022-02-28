require "test_helper"

class DynamicPageControllerTest < ActionDispatch::IntegrationTest
  test "should get init_Suisei" do
    get dynamic_page_init_Suisei_url
    assert_response :success
  end
end

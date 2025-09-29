require "test_helper"

class UsagesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get usages_index_url
    assert_response :success
  end
end

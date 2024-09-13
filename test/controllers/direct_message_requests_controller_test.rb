require "test_helper"

class DirectMessageRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get direct_message_requests_create_url
    assert_response :success
  end

  test "should get update" do
    get direct_message_requests_update_url
    assert_response :success
  end
end

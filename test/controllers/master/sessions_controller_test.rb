require 'test_helper'

class Master::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get master_sessions_new_url
    assert_response :success
  end

end

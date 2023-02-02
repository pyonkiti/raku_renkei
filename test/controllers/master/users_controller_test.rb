require 'test_helper'

class Master::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get master_users_new_url
    assert_response :success
  end

  test "should get edit" do
    get master_users_edit_url
    assert_response :success
  end

  test "should get show" do
    get master_users_show_url
    assert_response :success
  end

  test "should get index" do
    get master_users_index_url
    assert_response :success
  end

end

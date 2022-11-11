require 'test_helper'

class Con37NyushiSeikyusControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get con37_nyushi_seikyus_index_url
    assert_response :success
  end

end

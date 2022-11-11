require 'test_helper'

class Con37NyushiExcelsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get con37_nyushi_excels_index_url
    assert_response :success
  end

end

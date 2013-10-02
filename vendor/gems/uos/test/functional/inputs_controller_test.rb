require 'test_helper'

class InputsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end

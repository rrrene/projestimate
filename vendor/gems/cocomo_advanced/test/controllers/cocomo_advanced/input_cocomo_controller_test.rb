require 'test_helper'

module CocomoAdvanced
  class InputCocomoControllerTest < ActionController::TestCase
    test "should get index" do
      get :index
      assert_response :success
    end

  end
end

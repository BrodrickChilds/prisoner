require 'test_helper'

class GamesControllerTest < ActionController::TestCase
  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get respond" do
    get :respond
    assert_response :success
  end

end

require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  
  
  test "should get index" do
    get teams_path
    assert_response :success
  end
  
  test "should get import path" do
    get teams_import_path
    assert_response :success
  end
  
  test "should get new" do
    get teams_new_path
    assert_response :success
  end
end
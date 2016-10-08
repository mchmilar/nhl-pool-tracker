require 'test_helper'

class PlayersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @group = Group.create(name: "test group", op_id_number: 1111111)
    @player = Player.new(name: "Mark Chmilar", lwl_rank: 600, position: "C", lwl_pts: 200, group_id: 1)
    @player.save
    
  end
  
  test "should get index" do
    get root_path
    assert_response :success
  end
  
end
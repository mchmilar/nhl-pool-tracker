require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  def setup
    @player = Player.new(name: "Mark Chmilar", lwl_rank: 600, position: "C", lwl_pts: 200, group_id: 1)
  end
  
  test "should be valid" do
    assert @player.valid?
  end
  
  test "name should be present" do
    @player.name = "    "
    assert_not @player.valid?
  end
  
  test "lwl_pts should be present" do
    @player.lwl_pts = nil
    assert_not @player.valid?
  end
  
  test "name should be unique" do
    duplicate_player = @player.dup
    @player.save
    assert_not duplicate_player.valid?
  end
end
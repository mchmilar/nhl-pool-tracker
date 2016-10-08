require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  def setup
    @team = Team.new(name: "test")  
  end
  
  test "should be valid" do
    assert @team.valid?
  end
  
  test "name should be present" do
    @team.name = "   "
    assert_not @team.valid?
  end
  
  test "name should be unique" do 
    dup_team = @team.dup
    @team.save
    assert_not dup_team.valid?
  end
end
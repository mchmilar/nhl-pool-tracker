require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def setup
    @group = Group.new(name:"test", op_id_number:"1234567")
  end
  
  test "should be valid" do
    assert @group.valid?
  end
  
  test "name should be present" do
    @group.name = "  "
    assert_not @group.valid?
  end
  
  test "op_id_number should be present" do
    @group.op_id_number = nil
    assert_not @group.valid?
  end
  
  test "name should be unique" do
    duplicate_group = @group.dup
    @group.save
    assert_not duplicate_group.valid?
  end
  
  test "op_id_number should be unique" do
    duplicate_group = @group.dup
    @group.save
    assert_not duplicate_group.valid?
  end
  
  test "should get op group numbers" do 
    returned_hash = Group.send(:get_op_groups, "http://www.officepools.com/nhl/classic/214525/data-2016.10.05.14.23.30.307415.js")
    expected_hash = {"4056458"=>"Al & Ryan", "4056482"=>"The Great Brett Breaksky", "4056480"=>"JBM", "4056478"=>"CBC", "4056477"=>"Shithawks", "4056476"=>"Shithawks Part Deux", "4056475"=>"Shane & Dom", "4056474"=>"Paul", "4056473"=>"Como Rose", "4056471"=>"Matt & Dave", "4056470"=>"The Bloods", "4056469"=>"Village Idiot", "4056468"=>"Charley", "4056466"=>"Hurtin Albertans", "4056465"=>"Cam & Tasso", "4056464"=>"Jim & Tim", "4056463"=>"D.J.", "4056461"=>"Dennis & Bruce", "4056460"=>"Chris", "4056459"=>"Gilles", "4056483"=>"Mr.Saturday Night", "4056484"=>"Martin"}
    assert_equal expected_hash, returned_hash
  end
  
  test "should get op group players" do
    returned_array = Group.send(:get_op_group_players, "http://www.officepools.com/nhl/classic/214525/data-2016.10.06.07.00.34.927959.js/4056466.js")
    expected_array = ["4961", "4246", "3041", "3801", "6374", "3614", "4383", "3861", "4265", "4629", "4939", "5777"]
    assert_equal expected_array, returned_array
  end
end
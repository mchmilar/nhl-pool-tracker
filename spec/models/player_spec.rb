require 'rails_helper'
require 'spec_helper'

describe Player, type: :model do
  it "has a valid factor" do
    player = FactoryGirl::build(:player)
    expect(player).to be_valid
  end
end

describe Player do
  before do
    @player = FactoryGirl::build(:player)
  end

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { should respond_to(:name) }
  it { should respond_to(:lwl_rank) }
  it { should respond_to(:lwl_pts) }
  it { should respond_to(:gp) }
  it { should respond_to(:group_id) }
  it { should respond_to(:team_id) }
  it { should respond_to(:draft_pos) }

  describe "when name is not present" do
    it "should not be valid" do
      @player.name = " "
      expect(@player).not_to be_valid
    end
  end

  describe "when name is not unique" do
    before do
      duplicate_player = @player.dup
      duplicate_player.name = @player.name.upcase
      duplicate_player.save
    end
    it { should_not be_valid }
  end


end
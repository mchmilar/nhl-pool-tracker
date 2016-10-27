require 'rails_helper'
require 'spec_helper'

describe Team, type: :model do
  it "has a valid factor" do
    team = FactoryGirl::build(:team)
    expect(team).to be_valid
  end
end

describe Team do
  before do
    @team = FactoryGirl::build(:team)
  end

  it { is_expected.to validate_presence_of(:teamFullName) }
  it { is_expected.to validate_presence_of(:teamAbbrev) }

  it { is_expected.to validate_uniqueness_of(:teamFullName).case_insensitive }
  it { is_expected.to validate_uniqueness_of(:teamAbbrev).case_insensitive }

  it { is_expected.to validate_length_of(:teamAbbrev) }

end
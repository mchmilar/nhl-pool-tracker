require 'rails_helper'
require 'spec_helper'

RSpec.feature "PlayersIndices", type: :feature do
  describe "GET /players" do
    it "should have correct title" do
      visit players_path
      expect(page).to have_title("Players | NHL Pool Tracker")
    end
  end
end

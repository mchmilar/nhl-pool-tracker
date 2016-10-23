require 'rails_helper'

RSpec.describe "PlayersIndices", type: :request do
  describe "GET /players_indices" do
    it "works! (now write some real specs)" do
      get players_indices_path
      expect(response).to have_http_status(200)
    end
  end
end
